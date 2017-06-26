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

##      set_permissions

##  ------------------------------------------------------------------------  ##
##                                    LOGGERS                                 ##
##  ------------------------------------------------------------------------  ##

function log () {
    echo -en "\n${White}[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]:\t" "${@}" "\n${NC}";
}


function info () {
    echo -en "\n${BBlue}[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]:\t" "${@}${NC}";
}


function warn () {
    echo -en "\n${BYellow}[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]:\t" "${@}${NC}";
}


function error () {
    echo -en "\n${BRed}[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]:\t" "${@}" "\n${NC}" 1>&2;
}


function fatal () {
    echo -e "\n${BRed}";
    echo -ne "****************** $FUNCNAME *************************"
    echo -ne "%s\n" "$@"
    echo -ne "****************** $FUNCNAME *************************\n${NC}"
}


function splash () {
    echo -ne "\n${BCyan}";
    echo -ne "****************** === *************************\n"
    echo -ne "[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]:\t" "${@}" "\n";
    echo -ne "****************** === *************************\n${NC}"
}

##  ------------------------------------------------------------------------  ##
##                             Timeout Helper                                 ##
##  ------------------------------------------------------------------------  ##

function Delay () {
    local T=1;
    printf "\nTimeout ${T} second(s) ... ";
    sleep ${T};
    printf "DONE\n";
    # exit 0;
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
##                              PERMISSIONS
##  ------------------------------------------------------------------------  ##
function set_permissions {
    W_DIR="$1"
    printf "\n------------------  SET PERMISSIONS  ------------------------\n";
    info "W_DIR = ${W_DIR}"
    sudo chown -R root:"${WEB_USER}" "${W_DIR}"
    sudo chmod 775 "${W_DIR}"

    cd "${W_DIR}"
    sudo find . -type d -exec chmod 775 {} \;
    sudo find . -type f -exec chmod 664 {} \;

    printf "PERMISSIONS CHANGED FOR: [${W_DIR}] \n\n";
    printf "======================================================\n";
}

