#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  ENGINE
##  ------------------------------------------------------------------------  ##
##  - Setup laravel/installer
##  - Download, install and configure latest Laravel Framework

##  Consists of:
##      check_engine
##      engine_setup
##      fix_permissions


function check_engine {
    if [ ! -d "${ENGINE_DIR}" ]; then
        warn "[WARNING]\tEngine directory ${ENGINE_DIR} not found!\n";
        log "[LOG]\tStarting engine setup ... \n";
        engine_setup
        fix_permissions
        # exit 1
    fi
}


function engine_setup {
    composer -vvv create-project --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${ENGINE_DIR}" "${ENGINE_VERSION}.*"
    # cp -prv "${ENGINE_DIR}" build/ && cp -prv setup.rc build/.env && cd build && composer -vvv update && cd ..
    info "[INFO]\tEngine ${ENGINE_NAME}-${ENGINE_VERSION} deployed to ${ENGINE_DIR} \n";
}


function fix_permissions {
    cd "${APP_HOME}"
    sudo chown -R root:${WEB_USER} ${ENGINE_DIR}
    sudo chmod 775 "${ENGINE_DIR}"
    sudo chmod 775 "${ENGINE_DIR}/storage"
    sudo chmod 775 "${ENGINE_DIR}/bootstrap/cache"
}

##  ------------------------------------------------------------------------  ##
