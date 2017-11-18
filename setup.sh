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
# - Consist of:
#   -   usage
#   -   preSetupChecks
#   -   depsChecks
#   -   Build
#   -   Deploy

if [ -n "$APP_DEBUG" ]; then
  set -x
fi

set -e
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

##  Colors
if [ -f ./bin/.bash_colors ]; then
  source ./bin/.bash_colors
  echo -e "\t${BPurple}ENV:\t exported [./bin/.bash_colors]${NC}";
fi

## Source settings
if [ ! -f ./setup.rc ]; then
  printf "Missing file [setup.rc]\n"
  exit 1
fi
source ./setup.rc
echo -e "\t${BYellow}ENV:\t exported [./setup.rc]${NC}";


function usage () {
  >&2 cat << EOM
            Build project ecosystem

  Usage:
    $0 <command> [<params>]

    $0 <usage | help | h>   -   Show usage information
    $0 <test | t>           -   Perform environment tests
    $0 <prepare | prep | p> -   Install PHP, BOWER and NPM dependencies.
    $0 <build | b>          -   Build project directory
    $0 <deploy | d>         -   Sync sites public web directory (<webroot> by default)
    $0 <rebuild | rb>       -   Perform <build> and then <deploy> tasks

EOM
  # RETVAL=1;
}

##  root password for sudo operations
echo "Please enter your sudo Password: "
# read -s SUDO_PASS_INPUT
# export SUDO_PW=${SUDO_PASS_INPUT}
sudo -v

##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##

OPTS=$@

WD="$(pwd -P)"                          #   Current working directory
APP_HOME="$(pwd -P)/"                   #   Current directory
APP_PATH="${APP_HOME}${APP_DIR}"        #   Full path to target directory
ENGINE_DIR="${ENGINE_NAME}-${ENGINE_VERSION}"

CODE_VERSION="$(cat ./VERSION)"
GIT_COMMIT="$(git rev-list --remove-empty --remotes --max-count=1 --date-order --reverse)"

printf "${GIT_COMMIT}" > COMMIT

SRC="${WD}/src"
BUILD="${WD}/build"
DIST="${WD}/dist"

DATE="$(date +"%Y%m%d%H%M%S")"
DATETIME="$(date "+%Y-%m-%d")_$(date "+%H-%M-%S")"

# for D in "${BUILD}" "${DIST}"
#   do
#     mkdir -p "${D}"
#   done


# printf "\n----------------------------  ${DATE}  ---------------------------\n";

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
  splash "$FUNCNAME Started with: (${@})";

  info "CODE_VERSION =  ${CODE_VERSION}";
  info "GIT_COMMIT = \t ${GIT_COMMIT}";
  info "WD = \t\t ${WD}";
  info "SRC = \t\t ${SRC}";
  info "BUILD = \t ${BUILD}";
  info "DIST = \t ${DIST}";
  info "ENGINE_DIR = \t ${ENGINE_DIR}";
  info "APP_PATH = \t ${APP_PATH}";
  info "WEB_USER = \t ${WEB_USER}";
  info "OPTS = \t ${OPTS}";

  splash "$FUNCNAME Finished";
  return 0;
}

##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##


function preSetupChecks () {
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

function depsChecks () {
  splash "$FUNCNAME Started with: (${@})";

  createDirTree "${BUILD} ${DIST}"
  Delay

  composer_check
  Delay

  engine_check
  Delay

  # fix_permissions
  # Delay

  # deps_install
  # Delay

  # deps_outdated
  # sleep 1;

  splash "$FUNCNAME Finished";
  # exit 0;
}


function Build () {
  splash "$FUNCNAME Started with: (${@})";

  # mkdir -p ${BUILD} # && chmod 775 ${BUILD}
  # mkdir -p ${BUILD}
  # set_permissions ${BUILD}

  # cd ${WD}
  # node gulpfile.js --env=${APP_ENV} #--verbose
  # Delay


  cd ${WD}
  cp -prv ${ENGINE_DIR}/* "${BUILD}/" 2>/dev/null
  warn "Engine directory [${ENGINE_DIR}] COPIED to [${BUILD}/]";
  # mv -p "${BUILD}/.env" "${BUILD}/.env.${DATE}" 2>/dev/null
  # cp -prv setup.rc "${BUILD}/.env"
  # info "COPIED setup.rc to [${BUILD}/.env]";
  # cp -pr "${SRC}/composer.json" "${BUILD}/"
  # warn "COPIED [${SRC}/composer.json] to [${BUILD}/]";
  # cd "${BUILD}" && composer -vvv update && cd -


  cp -prv "${SRC}/.env" "${BUILD}/"
  cp -prv "${SRC}/composer.json" "${BUILD}/"
  Delay

  # cd ${BUILD}
  # composer -v update
  # Delay

  # cd ${WD}
  # set_permissions ${BUILD}
  # Delay

  splash "$FUNCNAME Finished";
  # exit 0;
}


function Deploy () {
  splash "$FUNCNAME params: (${@})";

  mkdir -p "${WD}/${APP_DIR}/public/";
  set_permissions ${WD}/${APP_DIR};

  cd ${WD}
  node gulpfile.js sync:web --env=${APP_ENV} --verbose        \
  && Delay;

  cd ${WD}
  cd "${WD}/${APP_DIR}/public/"
  ln -s ../storage/media/audio/ >&2 2>/dev/null               \
  && Delay;

  cd ${WD}
  sudo chown -R ${WEB_USER}:${WEB_USER} "${APP_DIR}"          \
  && Delay;

  node gulpfile.js artisan:clear --env=${APP_ENV} --verbose   \
  && Delay;

  splash "$FUNCNAME Finished";
  # exit 0;
}


##  ------------------------------------------------------------------------  ##
##                                  EXECUTION                                 ##
##  ------------------------------------------------------------------------  ##
printf "\n-------------------------\t $0 $1 \t----------------------------\n";

logEnv

case "$1" in

  "")
    log "without params";
    usage
    RETVAL=0
  ;;

  "usage" | "h")
    log "usage()";
    usage
    RETVAL=0
  ;;

  "test" | "t")
    log "test()";
    preSetupChecks
    RETVAL=$?
  ;;

  "tree")
    log "tree()";
    createDirTree "${BUILD} ${DIST}"
    RETVAL=$?
  ;;

  "prepare" | "prep" | "p")
    log "prepare()";
    depsChecks
    RETVAL=$?
  ;;

  "build" | "b")
    info "build()";
    Build && Delay
    RETVAL=$?
  ;;

  "rebuild" | "rb")
    info "REbuild()";
    Build && Delay
    Deploy && Delay
    RETVAL=$?
  ;;

  "deploy" | "d")
    info "deploy()";
    Deploy
    RETVAL=$?
  ;;

  "all" | "a")
    info "all()";
    preSetupChecks && Delay
    depsChecks && Delay
    Build && Delay
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
