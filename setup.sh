#!/usr/bin/env bash
#
#   Script to initialize repo
# - install required node packages
# - install Karma
# - install git hooks

source setup.rc

##  ------------------------------------------------------------------------- //
##  PREREQUISITES
##  ------------------------------------------------------------------------- //
APP_HOME="$(pwd)/"
APP_PATH="${APP_HOME}${APP_DIR}"

printf "[INFO]\tAPP_PATH=${APP_PATH}\n";


##  ------------------------------------------------------------------------- //
##  NODEJS
##  ------------------------------------------------------------------------- //
node=`which node 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install NodeJS\n";
    printf "[INFO]\thttp://nodejs.org/\n";
    exit 1
fi
printf "[OK]\tNodeJS $(node -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  NPM
##  ------------------------------------------------------------------------- //
npm=`which npm 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install NPM\n";
    exit 1
fi
printf "[OK]\tNPM v$(npm -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  BOWER
##  ------------------------------------------------------------------------- //
bower=`which bower 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install Bower\n";
    exit 1
fi
printf "[OK]\tBower v$(bower -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  KARMA
##  ------------------------------------------------------------------------- //
# karma=`which karma 2>&1`
# if [ $? -ne 0 ]; then
  # printf "Installing Karma ... \n";
  # npm install -g karma
# fi
#printf "[OK]\tKarma Installed\n";


##  ------------------------------------------------------------------------- //
##  GIT HOOKS
##  ------------------------------------------------------------------------- //
# printf "[info] Installing git hooks ... \n"
# ln -sf ../../validate-commit-msg.js .git/hooks/commit-msg

##  ------------------------------------------------------------------------- //
##  SCENARIO
##  ------------------------------------------------------------------------- //
#1.  git clone https://github.com/tbaltrushaitis/mp3.git mp3 && cd mp3
#2.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
#3.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd ..
#4.  npm i && bower i

#//  GIT
#git pull origin tagsInput

#//  CLEAN
#gulp clean:build
#gulp clean:dist
#gulp clean:resources
#gulp clean:public


# gulp bower
#gulp bower:fonts
#gulp bower:css:fonts
#gulp bower:css:plugins
#gulp bower:js
#gulp bower:plugins

# deploy
#gulp sync:web
#gulp artisan:clear


# clean
#[   'clean:build'
#  , 'clean:dist']

#deploy -> sync:web, artisan:clear

##  ------------------------------------------------------------------------- //
##  #   COMPOSER
##  ------------------------------------------------------------------------- //
function composer_setup {
    SIGNATURE_EXPECTED=$(wget http://composer.github.io/installer.sig -O - -q)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    SIGNATURE_ACTUAL=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$SIGNATURE_EXPECTED" = "$SIGNATURE_ACTUAL" ]
    then
        printf "[OK]\tCorrect installer signature [$SIGNATURE_ACTUAL]\n"
        php composer-setup.php --install-dir=/bin --filename=composer
        RESULT=$?
        mv composer-setup.php composer-setup-DONE-$(date +"%s").php
        printf "[LOG]\tCOMPOSER INSTALL FINISHED\n"
        exit $RESULT
    else
        >&2 printf '[ERROR]\tInvalid installer signature\n'
        mv composer-setup.php composer-setup-INVALID-$(date +"%s").php
        exit 1
    fi
}

function composer_selfupdate {
    composer -vvv selfupdate
    printf "[LOG]\tCOMPOSER UPDATED\n"
}

function check_composer {
    _composer=`which composer 2>&1`
    if [ $? -ne 0 ]; then
        printf "[WARNING]\tComposer not found!\n";
        printf "[INFO]\thttp://getcomposer.org/\n";
        printf "[LOG]\tStarting composer setup ... \n";
        # composer_setup
        # composer_selfupdate
        # exit 1
    fi
}

##  ------------------------------------------------------------------------- //
##  ENGINE
##  ------------------------------------------------------------------------- //
function engine_setup {
    composer -vvv create-project --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${ENGINE_DIR}" "${ENGINE_VERSION}.*"
    cp -prv "${ENGINE_DIR}" build/ && cp -prv setup.rc build/.env && cd build && composer -vvv update && cd ..
}

function check_engine {
    ENGINE_DIR="${ENGINE_NAME}-${ENGINE_VERSION}"
    if [ ! -d "${ENGINE_DIR}" ]; then
        printf "[WARNING]\tEngine directory ${ENGINE_DIR} not found!\n";
        printf "[LOG]\tStarting engine setup ... \n";
        engine_setup
        # exit 1
    fi
}

##  ------------------------------------------------------------------------- //
##  GIT
##  ------------------------------------------------------------------------- //
function git_update {
    git branch
    git fetch
    git pull origin "${GIT_BRANCH}"
    git branch
}

function check_git {
    if [ ! -d ".git" ]; then
        printf "[WARNING]\tCloning repo from git: ${GIT_REPO} ... \n";
        git clone -b "${GIT_BRANCH}" "${GIT_REPO}" "${APP_DIR}"
        cp -prv --copy-contents ${APP_DIR}/.* .
        rm -rf ${APP_DIR}
    fi
    printf "[OK]\tRunning in git repository\n";
}

##  ------------------------------------------------------------------------- //
##  NPM and BOWER DEPENDENCIES
##  ------------------------------------------------------------------------- //
function deps_install {
    printf "[LOG]\tInstalling required npm packages ... \n";
    npm i

    printf "[LOG]\tInstalling required Bower packages ... \n";
    bower i --verbose
}

function deps_outdated {
    npm outdated
    bower list
}

##  ------------------------------------------------------------------------- //
##  EXECUTION
##  ------------------------------------------------------------------------- //
check_composer
check_engine
check_git

git_update
deps_install
deps_outdated

printf "\n\n[LOG]\tALL DONE\n"
##  --------------------------  EOF: setup.sh  -----------------------------  //
