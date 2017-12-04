#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  ENGINE
##  ------------------------------------------------------------------------  ##
##  - Setup laravel/installer
##  - Download, install and configure Laravel Framework

##  Provides:
##    engine_check()
##    engine_setup()
##    engine_set_permissions()


function engine_check {
  if [ ! -d ${DIR_ENGINE} ]; then
    error "Engine directory [${DIR_ENGINE}] not found!";
    warn "Starting engine setup ... ";
    engine_setup
    engine_set_permissions
    # exit 1
  fi
}


function engine_setup {
  # composer -vvv create-project --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${ENGINE_DIR}" "${ENGINE_VERSION}.*"
  git clone -b "v${ENGINE_VERSION}" "https://github.com/laravel/laravel" ${DIR_ENGINE}
  warn "Engine [${ENGINE_NAME}-${ENGINE_TAG}] sources CLONED to [${DIR_ENGINE}]";
  # cp -pr ${ENGINE_DIR}/* build/
  # warn "Engine directory [${ENGINE_DIR}] COPIED to [build/]";
  # cp -prv setup.rc build/.env
  # warn "COPIED setup.rc to [build/.env]";
  # cd build && composer -vvv update && cd ..
}


function engine_set_permissions {
  cd ${APP_HOME}
  # sudo chown -R ${WEB_USER}:${WEB_USER} ${DIR_ENGINE}
  chmod 775 ${DIR_ENGINE}
  chmod 775 ${DIR_ENGINE}/storage
  chmod 775 ${DIR_ENGINE}/bootstrap/cache
  chmod a+x ${DIR_ENGINE}/artisan
}

##  -----------------------  EOF: f-engine.sh  -----------------------------  ##
