#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##                   Build project's working directory                        ##
##  ------------------------------------------------------------------------  ##

set -e
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

function usage () {
    >&2 cat << EOM
            ${BWhite}Build application${NC}

Usage: $0 <command> [<params>]

    $0 usage                    -   show usage information
    $0 <image | i> [<image_id>] -   build image

EOM
    RETVAL=1
}

#
#   Script to initialize repo
# - install required node packages
# - install git hooks

source setup.rc

##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##

OPTS=$@

WD="$(cd $(dirname $0) && pwd -P)"   #   Current working directory
APP_HOME="$(pwd)/"                      #   Current directory
APP_PATH="${APP_HOME}${APP_DIR}"        #   Full path to target directory
WEB_USER="www-data"                     #   Group of webserver used on host
ENGINE_DIR="${ENGINE_NAME}-${ENGINE_VERSION}"
CODE_VERSION="$(cat ./VERSION)"

BUILD="${WD}/build"
SRC="${WD}/src"
DIST="${WD}/dist"

DATE="$(date +"%Y%m%d%H%M%S")"
DATETIME="$(date "+%Y-%m-%d")_$(date "+%H-%M-%S")"

# printf "\n----------------------------  ${DATE}  ---------------------------\n";

##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##

source bin/f.sh
source bin/f-engine.sh
source bin/f-node.sh
source bin/f-php-composer.sh
source bin/host-checks.sh


function preSetupChecks () {
    info "\t$FUNCNAME params: \t [$@]\n";

    okNode
    okNpm
    okBower
    okGulp

}

info "WD = \t ${WD}";
info "BUILD = \t ${BUILD}";
info "SRC = \t ${SRC}";
info "CODE_VERSION = \t ${CODE_VERSION}";
info "APP_PATH = \t ${APP_PATH}";
info "ENGINE_DIR = \t ${ENGINE_DIR}";


##  ------------------------------------------------------------------------  ##
##                                 GIT HOOKS                                  ##
##  ------------------------------------------------------------------------  ##
##  printf "[info] Installing git hooks ... \n"
##  ln -sf ../../validate-commit-msg.js .git/hooks/commit-msg

##  ------------------------------------------------------------------------  ##
##                                 SCENARIO                                   ##
##  ------------------------------------------------------------------------  ##
##  1.  git clone https://github.com/tbaltrushaitis/mp3web.git -b "dev-1.0.2" mp3web
##  2.  sudo chown -R www-data:www-data mp3web && cd mp3web && sudo rights
##  3.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
##  4.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd -
##  5.  ./setup.sh
##  6.  npm i && bower i

# deploy
#gulp sync:web
#gulp artisan:clear

#deploy -> sync:web, artisan:clear
# php artisan key:generate
##  ------------------------------------------------------------------------  ##
##                                 EXECUTION                                  ##
##  ------------------------------------------------------------------------  ##

function depsChecks () {
    info "\t$FUNCNAME params: \t [$@]\n";

    check_composer
    sleep 1;

    check_engine
    sleep 1;

    # fix_permissions
    # sleep 1;

    deps_install
    sleep 1;
}

# check_git

# git_update
# sleep 1;

# deps_outdated
# sleep 1;


function Build () {
    info "\t$FUNCNAME params: \t [$@]\n";

    cd ${WD}
    gulp --env=${APP_ENV} #--verbose
    sleep 1;

    cd ${WD}
    cp -pr ./setup.rc "${BUILD}/.env.setup"

    cd build/
    composer -vvv update

    sudo chown -R ${WEB_USER}:${WEB_USER} "${BUILD}/"
    sleep 1;

}


function Deploy () {
    printf "\t$FUNCNAME params: \t [$@]\n";

    cd ${WD}
    gulp sync:web --env=${APP_ENV} --verbose
    sleep 1;

    cd ${WD}
    cd "${BUILD}/public/"
    ln -s ../storage/media/audio/ 1>&2 2>/dev/null
    sleep 1;

    cd ${WD}
    sudo chown -R "${WEB_USER}":"${WEB_USER}" "${APP_DIR}"
    sleep 1;

    gulp artisan:clear --env=${APP_ENV} --verbose
    sleep 1;

}


# gulp deploy  --env=dev --verbose

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

##  ------------------------------------------------------------------------  ##
##                                  EXECUTION                                 ##
##  ------------------------------------------------------------------------  ##
printf "\n-------------------------\t $0 $1 \t----------------------------\n";

case "$1" in

    "")
        usage
        RETVAL=1
    ;;

    "usage" | "help" | "h")
        splash "usage()";
        usage
        RETVAL=1
    ;;

    "test" | "t")
        splash "test()";
        $0 "pre"
        $0 "deps"
        RETVAL=$?
    ;;

    "pre")
        splash "pre()";
        preSetupChecks
        RETVAL=$?
    ;;

    "deps")
        splash "deps()";
        depsChecks
        RETVAL=$?
    ;;

    "build" | "install" | "i" | "b")
        splash "Build()";
        Build
        RETVAL=$?
    ;;

    "rebuild" | "rb")
        splash "REbuild()";
        Build
        Deploy
        RETVAL=$?
    ;;

    "deploy")
        splash "deploy()";
        Deploy
        RETVAL=$?
    ;;

    *)
        RETVAL=1
    ;;

esac

printf "\n\n[LOG]\tALL DONE\n"

exit $RETVAL

##  --------------------------  EOF: setup.sh  -----------------------------  ##
