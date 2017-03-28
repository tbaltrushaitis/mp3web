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
source bin/f-node.sh
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
##  1.  git clone https://github.com/tbaltrushaitis/mp3.git mp3 && cd mp3
##  2.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
##  3.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd ..
##  4.  npm i && bower i

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


# check_composer
# check_engine
# check_git
# sleep 1;

# git_update
# sleep 1;


# gulp -vvv --env=production
# sleep 1;

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

printf "\n\n[LOG]\tALL DONE\n"
##  --------------------------  EOF: setup.sh  -----------------------------  ##
