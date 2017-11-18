#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  ENGINE
##  ------------------------------------------------------------------------  ##
##  - Setup laravel/installer
##  - Download, install and configure Laravel Framework

##  Provides:
##    engine_check()
##    engine_setup()
##    fix_engine_permissions()


function engine_check {
  if [ ! -d "${ENGINE_DIR}" ]; then
    warn "[WARNING]\tEngine directory ${ENGINE_DIR} not found!";
    log "Starting engine setup ... \n";
    engine_setup
    fix_engine_permissions
    # exit 1
  fi
}


function engine_setup {
  composer -vvv create-project --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${ENGINE_DIR}" "${ENGINE_VERSION}.*"
  # cp -prv "${ENGINE_DIR}" build/ && cp -prv setup.rc build/.env && cd build && composer -vvv update && cd ..
  info "Engine ${ENGINE_NAME}-${ENGINE_VERSION} deployed to ${ENGINE_DIR}";
}


function fix_engine_permissions {
  cd "${APP_HOME}"
  sudo chown -R ${WEB_USER}:${WEB_USER} ${ENGINE_DIR}
  sudo chmod 775 "${ENGINE_DIR}"
  sudo chmod 775 "${ENGINE_DIR}/storage"
  sudo chmod 775 "${ENGINE_DIR}/bootstrap/cache"
}

##  -----------------------  EOF: f-engine.sh  -----------------------------  ##
