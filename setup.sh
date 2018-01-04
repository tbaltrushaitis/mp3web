#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##                     Build project working directory                        ##
##  ------------------------------------------------------------------------  ##
#
#   Script to initialize project
# - Install required node and bower packages
# - Install framework engine
# - Update framework installation with project's source scripts.
# - Deploy dist code into public web
# - Provides:
#   - showBanner
#   - usage
#   - logEnv
#   - setupChecks
#   - engineChecks
#   - Build
#   - Release
#   - Deploy
#   - Artisan

BD=./bin

## SOURCES
F_COLORS=${BD}/.bash_colors
F_FUNCS=${BD}/f.sh
F_RC=./setup.rc

if [ -f ${F_COLORS} ]; then source ${F_COLORS}; fi  ## Colors
if [ -f ${F_FUNCS} ]; then source ${F_FUNCS}; fi    ## Functions

## Source settings
if [ ! -f ${F_RC} ]; then
  echo -e "${BRed}Missing file [${F_RC}]${NC}"
  exit 1
fi
source ${F_RC}

if [ -n "$APP_DEBUG" ]; then
  # set -x
  echo -e "${BPurple}[ENV] ${BYellow}DEBUG${NC} MODE ${BGreen}ENABLED${NC}"
fi

set -e
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

##  BANNER
function showBanner () {
  local BANNER=${BD}/BANNER
  if [ -f ${BANNER} ]; then cat ${BANNER}; fi
}

function usage () {
  >&2 cat << EOM
            Build project ecosystem

  Usage:
    $0 <command> [<params>]

    $0 <usage | help | h>   -   Show usage information
    $0 <setup | s>          -   Install PHP, BOWER and NPM dependencies.
    $0 <engine | e>         -   Download engine sources
    $0 <build | b>          -   Build project directory
    $0 <release | r>        -   Create compiled distro
    $0 <deploy | d>         -   Sync sites public web directory (<webroot> by default)
    $0 <rebuild | rb>       -   Perform <build> and then <deploy> tasks

EOM
  # RETVAL=1;
}

##  root password for sudo operations
# echo "Please enter your sudo Password: "
# read -s SUDO_PASS_INPUT
# export SUDO_PW=${SUDO_PASS_INPUT}
# sudo -v

##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##

OPTS=$@

WD=$(pwd -P)                     #   Current working directory
APP_HOME=$(pwd -P)               #   Current directory
# APP_PATH=${APP_HOME}/${APP_DIR}  #   Full path to target directory
DIR_ENGINE="${ENGINE_NAME}-${ENGINE_VERSION}"
CODE_VERSION=$(cat ./VERSION)

SRC="${WD}/src"
BUILD="${WD}/build-${CODE_VERSION}"
DIST="${WD}/dist-${CODE_VERSION}"

DATE=$(date +"%Y%m%d%H%M%S")
DATETIME=$(date "+%Y-%m-%d")_$(date "+%H-%M-%S")

##  ------------------------------------------------------------------------  ##
##                                 FUNCTIONS                                  ##
##  ------------------------------------------------------------------------  ##

# source ${BD}/f.sh
source ${BD}/f-database.sh
source ${BD}/f-engine.sh
source ${BD}/f-node.sh
source ${BD}/f-php-composer.sh
source ${BD}/f-host.sh

function logEnv () {
  splash "[$FUNCNAME] Started with: (${@})";

  info "[$FUNCNAME] CODE_VERSION = \t ${CODE_VERSION}";
  info "[$FUNCNAME] WD = \t\t ${WD}";
  info "[$FUNCNAME] DIR_SRC = \t ${DIR_SRC}";
  info "[$FUNCNAME] DIR_ENGINE = \t ${DIR_ENGINE}";
  info "[$FUNCNAME] DIR_BUILD = \t ${DIR_BUILD}";
  info "[$FUNCNAME] DIR_DIST = \t ${DIR_DIST}";
  info "[$FUNCNAME] DIR_WEB = \t ${DIR_WEB}";
  info "[$FUNCNAME] WEB_USER = \t ${WEB_USER}";
  info "[$FUNCNAME] OPTS = \t\t ${OPTS}";

  # info "SRC = \t\t ${SRC}";
  # info "BUILD = \t ${BUILD}";
  # info "DIST = \t\t ${DIST}";
  # info "APP_PATH = \t ${APP_PATH}";

  splash "[$FUNCNAME] Finished";
  return 0;
}

##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##


function setupChecks () {
  splash "[$FUNCNAME] Started with: (${@})";

  okNode
  okNpm
  okBower
  okGulp

  deps_install

  splash "[$FUNCNAME] Finished";
  return 0;
}


##  ------------------------------------------------------------------------  ##
##                                 EXECUTION                                  ##
##  ------------------------------------------------------------------------  ##

function engineChecks () {
  splash "[$FUNCNAME] Started with: (${@})";

  # createDirTree "${BUILD} ${DIST} ${DIR_WEB}"
  # Delay

  composer_check
  Delay

  engine_check
  Delay

  engine_set_permissions
  Delay

  splash "[$FUNCNAME] Finished";
  # exit 0;
}


function Build () {
  splash "[$FUNCNAME] Started with: (${@})"

  # local VERSION=$(versionn pre -e VERSION);
  # local DIR_BUILD="build-${VERSION}"

  # createDirTree ${DIR_BUILD} ${DIR_DIST}
  createDirTree "${DIR_BUILD}"
  Delay 2

  # mkdir -p ${BUILD} # && chmod 775 ${BUILD}
  # mkdir -p ${BUILD}
  # set_permissions ${BUILD}

  # cd ${WD}
  # node gulpfile.js --env=${APP_ENV} #--verbose
  # Delay


  cd ${WD}
  mkdir -p ${DIR_BUILD} 2>/dev/null
  cp -pr ${DIR_ENGINE}/* ${DIR_BUILD}/ 2>&1 >/dev/null
  warn "[$FUNCNAME] Engine directory [${DIR_ENGINE}] COPIED to [${DIR_BUILD}]"
  # cp -prv setup.rc "${BUILD}/.env"
  # info "COPIED setup.rc to [${BUILD}/.env]";
  # cp -pr "${SRC}/composer.json" "${BUILD}/"
  # warn "COPIED [${SRC}/composer.json] to [${BUILD}/]";
  # cd "${BUILD}" && composer -vvv update && cd -

  cd ${WD}

  if [ -f ${DIR_BUILD}/.env ]; then
    mv -vf ${DIR_BUILD}/.env ${DIR_BUILD}/.env.${DATE} 2>&1 >/dev/null
    warn "[$FUNCNAME] MOVED file [${DIR_BUILD}/.env] to [${DIR_BUILD}/.env.${DATE}]"
  fi

  cp -pr ${DIR_SRC}/* ${DIR_BUILD}/ 2>&1 >/dev/null && Delay 2
  cp -pvu ${DIR_SRC}/.env.rc ${DIR_BUILD}/.env 2>&1 && Delay 2
  cp -pvf ${DIR_SRC}/composer.json ${DIR_BUILD}/ 2>&1 && Delay 2

  # cd ${WD}
  # cp -prv ${SRC}/.* ${BUILD}/ 2>/dev/null
  # Delay

  cd ${DIR_BUILD}
  composer -v update
  cd ${WD} && Delay 2

  Artisan "${DIR_BUILD}"

  # cd ${WD}
  # set_permissions ${BUILD}
  # Delay

  splash "[$FUNCNAME] Finished"
}


function Release () {
  splash "[$FUNCNAME] params: (${@})";

  createDirTree "${DIR_DIST}";
  Delay 2;

  cd ${WD};
  cp -prv ${DIR_BUILD}/* ${DIR_DIST}/ 2>&1 >/dev/null;
  warn "[$FUNCNAME] Directory [${DIR_BUILD}] content DEPLOYED to [${DIR_DIST}]";
  cp -pvf ${DIR_BUILD}/.env ${DIR_DIST}/ 2>&1;
  warn "[$FUNCNAME] Directory [${DIR_BUILD}/.env] COPIED to [${DIR_DIST}/]";

  warn "[$FUNCNAME] Now RUN ARTISAN() with [${DIR_DIST}]";
  Artisan "${DIR_DIST}";
  warn "[$FUNCNAME] Now RETURNED from ARTISAN() with [${DIR_DIST}]";

  # cd ${WD}
  # cd "${DIR_WEB}/public"
  # mkdir -p ../storage/media/audio >&2 2>/dev/null
  # ln -s ../storage/media/audio >&2 2>/dev/null
  # cd -
  # Delay


  # cd ${WD}
  # sudo chown -R ${WEB_USER}:${WEB_USER} "${APP_DIR}"          \
  # && Delay;
  #
  # node gulpfile.js artisan:clear --env=${APP_ENV} --verbose   \
  # && Delay;

  splash "[$FUNCNAME] Finished";
}


function Deploy () {
  splash "$FUNCNAME params: (${@})";

  createDirTree "${DIR_WEB}";
  Delay 2;

  # mkdir -p "${WD}/${APP_DIR}/public/";
  # set_permissions ${WD}/${APP_DIR};

  # cd ${WD}
  # node gulpfile.js deploy --env=${APP_ENV} --verbose        \
  # && Delay;

  cd ${WD}
  cp -pr ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null
  warn "Directory [${DIR_DIST}/] content DEPLOYED to [${DIR_WEB}/]";
  if [ -f ${DIR_WEB}/.env ]; then
    mv -vf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null;
  fi
  cp -pvf ${DIR_DIST}/.env ${DIR_WEB}/ 2>&1 >/dev/null;
  warn "File [${DIR_DIST}/.env] COPIED to [${DIR_WEB}/.env]";
  Delay 2

  cd ${WD}
  cd ${DIR_WEB}/public
  mkdir -p ../storage/media/audio 2>&1 >/dev/null
  ln -s ../storage/media/audio 2>&1 >/dev/null
  cd ${WD}
  Delay 2

  # cd ${WD}
  # sudo chown -R ${WEB_USER}:${WEB_USER} "${APP_DIR}"          \
  # && Delay;
  #
  # node gulpfile.js artisan:clear --env=${APP_ENV} --verbose   \
  # && Delay;
  Artisan ${DIR_WEB}
  set_permissions ${DIR_WEB}

  splash "$FUNCNAME Finished";
}


function Artisan () {
  splash "[$FUNCNAME] Started with: (${@})";
  local W_DIR="$1";
  info "[$FUNCNAME] W_DIR = ${W_DIR}";

  cd ${W_DIR}
  info "[$FUNCNAME] PWD = $(pwd -P)";

  # chmod a+x artisan
  # ./artisan auth:clear-resets
  # ./artisan clear-compiled

  # php artisan route:clear;
  # php artisan view:clear;

  # ./artisan cache:clear
  cd ${W_DIR}
  php artisan -V > VERSION
  php artisan vendor:publish
  php artisan config:clear
  php artisan key:generate
  # php artisan optimize

  # ./artisan migrate:refresh
  # php artisan route:cache;

  php artisan down
  php artisan up

  # php artisan route:list
  # php artisan migrate:status

  # ./artisan config:cache

  splash "[$FUNCNAME] COMPLETED FOR: [${W_DIR}]";
  Delay 10;
}


##  ------------------------------------------------------------------------  ##
##                                  EXECUTION                                 ##
##  ------------------------------------------------------------------------  ##
echo -ne "\n${BYellow}------------------\t ${BRed} $0 ${NC} ${BPurple} $1 ${NC} \t${BYellow}----------------------\n${NC}";

# logEnv

case "$1" in

  "")
    info "[$FUNCNAME] Without params";
    usage;
    RETVAL=0
  ;;

  "usage" | "h")
    info "[$FUNCNAME] Usage()";
    usage;
    RETVAL=0
  ;;

  "setup" | "s")
    info "[$FUNCNAME] Setup()";
    setupChecks && Delay;
    RETVAL=$?
  ;;

  "tree")
    info "[$FUNCNAME] Tree()";
    createDirTree "${DIR_BUILD} ${DIR_DIST} ${DIR_WEB}" && Delay;
    RETVAL=$?
  ;;

  "engine" | "e")
    info "[$FUNCNAME] Engine()";
    engineChecks && Delay;
    RETVAL=$?
  ;;

  "build" | "b")
    info "[$FUNCNAME] Build()";
    Build && Delay;
    RETVAL=$?
  ;;

  "release" | "r")
    info "[$FUNCNAME] Release()";
    Release && Delay;
    RETVAL=$?
  ;;

  "deploy" | "d")
    info "[$FUNCNAME] Deploy()";
    Deploy && Delay;
    RETVAL=$?
  ;;

  "rebuild" | "rb")
    info "[$FUNCNAME] ReBuild()";
    Build && Delay;
    Release && Delay;
    RETVAL=$?
  ;;

  "redeploy" | "rd")
    info "[$FUNCNAME] ReDeploy()";
    Build && Delay 2;
    Release && Delay 2;
    Deploy && Delay 2;
    RETVAL=$?
  ;;

  "all" | "a")
    info "[$FUNCNAME] All_Tasks()";
    setupChecks && Delay 2;
    engineChecks && Delay 2;
    Build && Delay 2;
    Release && Delay 2;
    Deploy && Delay 2;
    # Artisan && Delay
    RETVAL=$?
  ;;

  *)
    fatal "[$FUNCNAME] UNKNOWN command: $1";
    usage;
    RETVAL=1
  ;;

esac

splash "ALL DONE! Exiting now ...";

exit ${RETVAL};

##  ------------------------------------------------------------------------  ##
##                                 SCENARIO                                   ##
##  ------------------------------------------------------------------------  ##
##  1.  git clone https://github.com/tbaltrushaitis/mp3web.git -b "dev-1.0.2" mp3web
##  2.  sudo chown -R www-data:www-data mp3web && cd mp3web && sudo rights
##  3.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
##  4.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd -
##  5.  ./setup.sh
##  6.  npm i && bower i

# git_update
# sleep 1;

# gulp deploy  --env=dev --verbose

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

# deploy
#gulp sync:web
#gulp artisan:clear

#deploy -> sync:web, artisan:clear
# php artisan key:generate
##  ------------------------------------------------------------------------  ##
##                                 GIT HOOKS                                  ##
##  ------------------------------------------------------------------------  ##
##  printf "[info] Installing git hooks ... \n"
##  ln -sf ../../validate-commit-msg.js .git/hooks/commit-msg

##  --------------------------  EOF: setup.sh  -----------------------------  ##
