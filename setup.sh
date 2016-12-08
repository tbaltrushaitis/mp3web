#!/usr/bin/env bash
#
#   Script to initialize repo
# - install required node packages
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
_node=`which node 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install NodeJS\n";
    printf "[INFO]\thttp://nodejs.org/\n";
    exit 1
fi
printf "[OK]\tNODEJS $(node -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  NPM
##  ------------------------------------------------------------------------- //
_npm=`which npm 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install NPM\n";
    exit 1
fi
printf "[OK]\tNPM v$(npm -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  BOWER
##  ------------------------------------------------------------------------- //
_bower=`which bower 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install Bower\n";
    exit 1
fi
printf "[OK]\tBOWER v$(bower -v) Installed\n";


##  ------------------------------------------------------------------------- //
##  GULP
##  ------------------------------------------------------------------------- //
_gulp=`which gulp 2>&1`
if [ $? -ne 0 ]; then
    printf "[ERROR]\tPlease install Gulp\n";
    exit 1
fi
printf "[OK]\tGULP Installed:\n$(gulp -v) \n";


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

# deploy
#gulp sync:web
#gulp artisan:clear


#deploy -> sync:web, artisan:clear

##  ------------------------------------------------------------------------- //
##  PHP COMPOSER
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
    printf "[LOG]\tCOMPOSER UPDATED to $(composer -V)\n"
}

function check_composer {
    _composer=`which composer 2>&1`
    if [ $? -ne 0 ]; then
        printf "[WARNING]\tComposer not found!\n";
        printf "[INFO]\thttp://getcomposer.org/\n";
        printf "[LOG]\tStarting composer setup ... \n";
        # composer_setup
        composer_selfupdate
        printf "[INFO]\tPlease run $# again.\n";
        # exit 1
    fi
    printf "[OK]\t$(composer -V) Installed\n";
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
    npm i -verbose

    printf "[LOG]\tInstalling required Bower packages ... \n";
    bower i --verbose
}

function deps_outdated {
    bower list
    npm outdated
}

##  ------------------------------------------------------------------------- //
##  EXECUTION
##  ------------------------------------------------------------------------- //

check_composer
check_engine
check_git
sleep 1;

git_update
sleep 1;

deps_install
sleep 1;

gulp -vvv --env=production
sleep 1;

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

printf "\n\n[LOG]\tALL DONE\n"
##  --------------------------  EOF: setup.sh  -----------------------------  //
