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
#   -   usage
#   -   logEnv
#   -   setupChecks
#   -   engineChecks
#   -   Build
#   -   Release
#   -   Deploy

##  BANNER
if [ -f ./BANNER ]; then
  cat BANNER
fi

if [ -n "$APP_DEBUG" ]; then
  # set -x
  printf "DEBUG MODE ENABLED\n"
fi

set -e
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

F_COLORS="./bin/.bash_colors"
F_RC="./setup.rc"

##  Colors
if [ -f ${F_COLORS} ]; then
  source ${F_COLORS}
  echo -e "\t${BPurple}ENV:\t exported [${F_COLORS}]${NC}";
fi

## Source settings
if [ ! -f ${F_RC} ]; then
  printf "Missing file [${F_RC}]\n"
  exit 1
fi
source ${F_RC}
echo -e "\t${BYellow}ENV:\t exported [${F_RC}]${NC}";


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

WD="$(pwd -P)"                          #   Current working directory
APP_HOME="$(pwd -P)/"                   #   Current directory
APP_PATH="${APP_HOME}${APP_DIR}"        #   Full path to target directory
DIR_ENGINE="${ENGINE_NAME}-${ENGINE_VERSION}"
CODE_VERSION="$(cat ./VERSION)"

SRC="${WD}/src"
BUILD="${WD}/build-${CODE_VERSION}"
DIST="${WD}/dist-${CODE_VERSION}"

DATE="$(date +"%Y%m%d%H%M%S")"
DATETIME="$(date "+%Y-%m-%d")_$(date "+%H-%M-%S")"

##  ------------------------------------------------------------------------  ##
##                                 FUNCTIONS                                  ##
##  ------------------------------------------------------------------------  ##

source bin/f.sh
source bin/f-database.sh
source bin/f-engine.sh
source bin/f-node.sh
source bin/f-php-composer.sh
source bin/host-checks.sh

function logEnv () {
  splash "${FUNCNAME}() Started with: (${@})";

  info "CODE_VERSION = \t ${CODE_VERSION}";
  info "WD = \t\t ${WD}";
  info "SRC = \t\t ${SRC}";
  info "BUILD = \t ${BUILD}";
  info "DIST = \t\t ${DIST}";
  info "DIR_ENGINE = \t ${DIR_ENGINE}";
  info "APP_PATH = \t ${APP_PATH}";
  info "WEB_USER = \t ${WEB_USER}";
  info "OPTS = \t\t ${OPTS}";

  splash "$FUNCNAME Finished";
  # return 0;
}

##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##


function setupChecks () {
  splash "$FUNCNAME Started with: (${@})";

  okNode
  okNpm
  okBower
  okGulp

  splash "$FUNCNAME Finished";
  return 0;
}


##  ------------------------------------------------------------------------  ##
##                                 EXECUTION                                  ##
##  ------------------------------------------------------------------------  ##

function engineChecks () {
  splash "$FUNCNAME Started with: (${@})";

  # createDirTree "${BUILD} ${DIST} ${DIR_WEB}"
  # Delay

  composer_check
  Delay

  engine_check
  Delay

  engine_set_permissions
  Delay

  deps_install
  Delay

  splash "$FUNCNAME Finished";
  # exit 0;
}


function Build () {
  splash "$FUNCNAME Started with: (${@})";

  # local VERSION=$(versionn pre -e VERSION);
  # local BUILD="build-${VERSION}"

  createDirTree ${BUILD}
  Delay

  # mkdir -p ${BUILD} # && chmod 775 ${BUILD}
  # mkdir -p ${BUILD}
  # set_permissions ${BUILD}

  # cd ${WD}
  # node gulpfile.js --env=${APP_ENV} #--verbose
  # Delay


  cd ${WD}
  mkdir -p ${BUILD} 2>/dev/null
  cp -prv ${DIR_ENGINE}/* ${BUILD} 2>/dev/null
  warn "Engine directory [${DIR_ENGINE}] COPIED to [${BUILD}]";
  # cp -prv setup.rc "${BUILD}/.env"
  # info "COPIED setup.rc to [${BUILD}/.env]";
  # cp -pr "${SRC}/composer.json" "${BUILD}/"
  # warn "COPIED [${SRC}/composer.json] to [${BUILD}/]";
  # cd "${BUILD}" && composer -vvv update && cd -


  cd ${WD}

  if [ -f ${BUILD}/.env ]; then
    mv -v ${BUILD}/.env ${BUILD}/.env.${DATE} 2>/dev/null
    Delay
  fi

  cp -pr ${SRC}/* ${BUILD} 2>/dev/null
  Delay
  cp -prv ${SRC}/.env ${BUILD} 2>/dev/null
  Delay
  cp -prv ${SRC}/composer.json ${BUILD} 2>/dev/null
  Delay

  # cd ${WD}
  # cp -prv ${SRC}/.* ${BUILD}/ 2>/dev/null
  # Delay

  cd ${BUILD}
  composer -v update
  cd -
  Delay

  # cd ${WD}
  # set_permissions ${BUILD}
  # Delay

  splash "$FUNCNAME Finished";
  # exit 0;
}


function Release () {
  splash "$FUNCNAME params: (${@})";

  cd ${WD}
  cp -pr ${BUILD} ${DIST} 2>/dev/null
  cp -prv ${BUILD}/.env ${DIST} 2>/dev/null
  warn "Directory [${BUILD}/*] content DEPLOYED to [${DIST}]";

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

  splash "$FUNCNAME Finished";
  # exit 0;
}


function Deploy () {
  splash "$FUNCNAME params: (${@})";

  # mkdir -p "${WD}/${APP_DIR}/public/";
  # set_permissions ${WD}/${APP_DIR};

  # cd ${WD}
  # node gulpfile.js deploy --env=${APP_ENV} --verbose        \
  # && Delay;

  cd ${WD}
  cp -pr ${DIST} ${DIR_WEB}/ 2>&1 >/dev/null
  if [ ! -f ${DIR_WEB}/.env ]; then
    cp -prv ${DIST}/.env ${DIR_WEB}/ 2>&1 > /dev/null
    info "ENV FILE [${DIST}/.env] COPIED to [${DIR_WEB}]";
  fi
  warn "Directory [${DIST}] content DEPLOYED to [${DIR_WEB}]";

  # cd ${WD}
  # cd "${WD}/${APP_DIR}/public/"
  # ln -s ../storage/media/audio/ >&2 2>/dev/null               \
  # && Delay;

  cd ${WD}
  cd ${DIR_WEB}/public
  mkdir -p ../storage/media/audio >&2 2>/dev/null
  ln -s ../storage/media/audio >&2 2>/dev/null
  cd -
  Delay

  # cd ${WD}
  # sudo chown -R ${WEB_USER}:${WEB_USER} "${APP_DIR}"          \
  # && Delay;
  #
  # node gulpfile.js artisan:clear --env=${APP_ENV} --verbose   \
  # && Delay;
  set_permissions ${DIR_WEB}

  splash "$FUNCNAME Finished";
  # exit 0;
}


##  ------------------------------------------------------------------------  ##
##                                  EXECUTION                                 ##
##  ------------------------------------------------------------------------  ##
printf "\n--------------------------\t $0 $1 \t-----------------------------\n";

logEnv

case "$1" in

  "")
    info "without params";
    usage
    RETVAL=0
  ;;

  "usage" | "h")
    info "usage()";
    usage
    RETVAL=0
  ;;

  "setup" | "s")
    info "setup()";
    setupChecks && Delay
    RETVAL=$?
  ;;

  "tree")
    info "tree()";
    createDirTree "${BUILD} ${DIST} ${DIR_WEB}" && Delay
    RETVAL=$?
  ;;

  "engine" | "e")
    info "engine()";
    engineChecks && Delay
    RETVAL=$?
  ;;

  "build" | "b")
    info "Build()";
    Build && Delay
    RETVAL=$?
  ;;

  "release" | "r")
    info "release()";
    Release && Delay
    RETVAL=$?
  ;;

  "deploy" | "d")
    info "deploy()";
    Deploy && Delay
    RETVAL=$?
  ;;

  "rebuild" | "rb")
    info "Recompile()";
    Compile && Delay
    Release && Delay
    RETVAL=$?
  ;;

  "all" | "a")
    info "All_Tasks()";
    preSetupChecks && Delay
    depsChecks && Delay
    Compile && Delay
    Release && Delay
    Deploy && Delay
    RETVAL=$?
  ;;

  *)
    fatal "UNKNOWN command: $1";
    usage
    RETVAL=1
  ;;

esac

splash "ALL DONE!";

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
