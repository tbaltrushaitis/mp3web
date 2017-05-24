#!/usr/bin/env bash
#
#   Script to initialize repo
# - install required node packages
# - install git hooks

source setup.rc

##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##

APP_HOME="$(pwd)/"                      #   Current directory
APP_PATH="${APP_HOME}${APP_DIR}"        #   Full path to target directory
WEB_USER="www-data"                     #   Group of webserver used on host
ENGINE_DIR="${ENGINE_NAME}-${ENGINE_VERSION}"


##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##

source bin/f.sh
source bin/f-engine.sh
source bin/f-node.sh
source bin/f-php-composer.sh
source bin/host-checks.sh

okNode
okNpm
okBower
okGulp

info "\tAPP_PATH=${APP_PATH}\n";
info "\tENGINE_DIR=${ENGINE_DIR}\n";

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

check_composer
sleep 1;

check_engine
sleep 1;

fix_permissions
sleep 1;

# check_git

# git_update
# sleep 1;

deps_install
sleep 1;
# deps_outdated
# sleep 1;

# gulp build:dev --env=dev #--verbose
gulp --env=${APP_ENV} #--verbose
sleep 1;

sudo chown -R ${WEB_USER}:${WEB_USER} build/
sleep 1;

gulp sync:web --env=${APP_ENV} --verbose
sleep 1;

sudo chown -R ${WEB_USER}:${WEB_USER} webroot/
sleep 1;

gulp artisan:clear --env=${APP_ENV} --verbose
sleep 1;

# gulp deploy  --env=dev --verbose

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

printf "\n\n[LOG]\tALL DONE\n"
##  --------------------------  EOF: setup.sh  -----------------------------  ##
