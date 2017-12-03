#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##                      f.sh:   Commonly Used Functions                       ##
##  ------------------------------------------------------------------------  ##

##  Consists of:
##      log
##      info
##      warn
##      error
##      fatal
##      splash

##      Delay

##      loadEnv
##      saveEnv

##      createDirTree
##      set_permissions

##  ------------------------------------------------------------------------  ##
##                                    LOGGERS                                 ##
##  ------------------------------------------------------------------------  ##

function log () {
  echo -ne "[$(date +'%Y%m%d%H%M%S')]${White}[$FUNCNAME]:\t" "${@}" ${NC} "\n";
}


function info () {
  echo -ne "[$(date +'%Y%m%d%H%M%S')]${BBlue}[$FUNCNAME]:" "${@}" ${NC} "\n";
}


function warn () {
  echo -ne "[$(date +'%Y%m%d%H%M%S')]${BYellow}[$FUNCNAME]:" "${@}" ${NC} "\n";
}


function error () {
  echo -ne "[$(date +'%Y%m%d%H%M%S')]${BRed}[$FUNCNAME]:" "${@}" ${NC} "\n" 1>&2;
}


function fatal () {
  echo -ne ${BRed};
  echo -ne "---------------------------  $FUNCNAME -------------------------\n";
  echo -ne "[$(date +'%Y%m%d%H%M%S')]: %s" "${@}" "\n";
  echo -ne "---------------------------  $FUNCNAME -------------------------\n";
  echo -ne ${NC};
}


function splash () {
  echo -ne ${BCyan};
  echo -ne "------------------------------ ==== ----------------------------\n";
  echo -ne "[$(date +'%Y%m%dT%H%M%S')]:" "${@}" "\n";
  echo -ne "------------------------------ ==== ----------------------------\n";
  echo -ne ${NC};
}

##  ------------------------------------------------------------------------  ##
##                             Timeout Helper                                 ##
##  ------------------------------------------------------------------------  ##

function Delay () {
  local T=1;
  echo -ne "${Green}Timeout ${T} second(s) ... ";
  sleep ${T};
  echo -e "${BGreen}[OK]${NC}";
}

##  ------------------------------------------------------------------------  ##
##              Load Environment Variables From .env Files                    ##
##  ------------------------------------------------------------------------  ##

function loadEnv () {

  local ENVD=$1
  ENVD=${ENVD:-.}
  ENV_LIST=$(ls ${ENVD}/.env.*)
  echo -ne "\n${BWhite}ENV: ENV_LIST = [${ENV_LIST}]${NC}";

  if [ ! "${ENV_LIST}" == "" ]; then
    for ENVF in ${ENV_LIST};
      do
        if [ -f "${ENVF}" ]; then
          . "${ENVF}";
          echo -ne "\n${BWhite}ENV: exported vars from [${ENVF}]:\n";
          cat "${ENVF}" | sed -e "s/^/\t/g"
        fi
      done
  fi

}


function saveEnv () {

  local ENVD=$1
  local ENVC=$2
  ENVD=${ENVD:-.}
  ENVC=${ENVC:-.env}
  local ENVDC=${ENVD}/${ENVC}

  ENV_LIST=$(ls ${ENVD}/.env.*)
  echo -ne "\n${BWhite}ENV \t ENV_LIST = [${ENV_LIST}]${NC}\n";

  if [ ! "${ENV_LIST}" == "" ]; then

    if [ -f "${ENVDC}" ]; then
      # mv -T "${ENVDC}" "${ENVDC}.$(date +"%s").bak"
      rm -f "${ENVDC}"
    fi

    # for ENVF in `ls ${ENVD}/.env.*`;
    for ENVF in ${ENV_LIST};
      do
        if [ -f "${ENVF}" ]; then
          . "${ENVF}";
          echo -ne "## Vars from [${ENVF}]\n" >> "${ENVDC}"
          # cat "${ENVF}" >> "${ENVDC}"
          # cat "${ENVF}" | sed -e '/^#/d' >> "${ENVDC}"
          sed -e '/^#/d' "${ENVF}" >> "${ENVDC}"
          echo -ne "\n" >> "${ENVDC}"
        fi
      done
  fi

}

##  ------------------------------------------------------------------------  ##
##                                FILESYSTEM                                  ##
##  ------------------------------------------------------------------------  ##

function createDirTree {
  warn "-----------------------  CREATE PROJECT DIRS  ------------------------";
  local TREE_LIST="$1";
  info "TREE_LIST = [${TREE_LIST}]";

  for D in ${TREE_LIST}
    do
      info "D = [${D}]";
      mkdir -p "${D}" 2>&1 >/dev/null;
    done

  warn "-------------------- FINISHED CREATE PROJECT DIRS --------------------";
  info "====================================================================\n";
}

function set_permissions {
  warn "-----------------------  SET PERMISSIONS  ----------------------------";
  W_DIR="$1"
  info "W_DIR = [${W_DIR}]";
  sudo chmod 775 ${W_DIR};
  sudo chown -R ${WEB_USER}:${WEB_GROUP} ${W_DIR}

  cd ${W_DIR}
  sudo find . -type d -exec chmod 775 {} \;
  sudo find . -type f -exec chmod 664 {} \;
  sudo find . -type f -name "*.sh" -exec chmod a+x {} \;

  cd ${W_DIR}
  sudo find . -type f -name "artisan" -exec chmod a+x {} \;

  warn "--------------- PERMISSIONS CHANGED FOR: [${W_DIR}] ------------------";
  info "====================================================================\n";
}
