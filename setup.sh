#!/usr/bin/env bash
#
#   Script to initialize repo
# - install required node packages
# - install git hooks

source setup.rc

##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##
APP_HOME="$(pwd)/"
APP_PATH="${APP_HOME}${APP_DIR}"

printf "[INFO]\tAPP_PATH=${APP_PATH}\n";

source bin/f.sh
source bin/f-engine.sh
source bin/f-node.sh
source bin/f-php-composer.sh
source bin/host-checks.sh

okNode
okNpm
okBower
okGulp
okGrunt

##  ------------------------------------------------------------------------  ##
##                                 GIT HOOKS                                  ##
##  ------------------------------------------------------------------------  ##
##  printf "[info] Installing git hooks ... \n"
##  ln -sf ../../validate-commit-msg.js .git/hooks/commit-msg

##  ------------------------------------------------------------------------  ##
##                                 SCENARIO                                   ##
##  ------------------------------------------------------------------------  ##
##  1.  git clone https://github.com/tbaltrushaitis/mp3web.git mp3web
##  2.  chown -R www-data:www-data mp3web && cd mp3web && rights
##  3.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
##  5.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd -
##  3.  ./setup.sh
##  6.  npm i && bower i

#//  GIT
#git pull origin tagsInput

# deploy
#gulp sync:web
#gulp artisan:clear

#deploy -> sync:web, artisan:clear

##  ------------------------------------------------------------------------  ##
##                                 EXECUTION                                  ##
##  ------------------------------------------------------------------------  ##

deps_install
sleep 1;
deps_outdated
sleep 1;

check_composer
sleep 1;

check_engine
sleep 1;

# check_git

# git_update
# sleep 1;


gulp --verbose --env=production
sleep 1;

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

printf "\n\n[LOG]\tALL DONE\n"
##  --------------------------  EOF: setup.sh  -----------------------------  ##
