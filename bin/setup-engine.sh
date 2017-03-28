#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  ENGINE
##  ------------------------------------------------------------------------  ##

function engine_setup {
    composer -vvv create-project --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${ENGINE_DIR}" "${ENGINE_VERSION}.*"
    # cp -prv "${ENGINE_DIR}" build/ && cp -prv setup.rc build/.env && cd build && composer -vvv update && cd ..
    printf "[INFO]\tEngine ${ENGINE_NAME}-${ENGINE_VERSION} deployed to ${ENGINE_DIR} \n";
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
