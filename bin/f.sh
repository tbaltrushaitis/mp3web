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

##  ------------------------------------------------------------------------  ##
##                                    LOGGERS                                 ##
##  ------------------------------------------------------------------------  ##

function log () {
    printf "[$FUNCNAME][$(date +'%Y%m%d%H%M%S')]\t%s\n" "$@";
}


function info () {
    echo -en "\n${BBlue}[$FUNCNAME]: ${NC}\t" "${@}";
}


function warn () {
    echo -en "\n${BYellow}[$FUNCNAME]:${NC}\t" "${@}";
}


function error () {
    echo -en "\n${BRed}[$FUNCNAME]:${NC}\t" "${@}" "\n" 1>&2;
}


function fatal () {
    echo -e "\n";
    echo -ne "****************** $FUNCNAME *************************"
    echo -ne "%s\n" "$@"
    echo -ne "****************** $FUNCNAME *************************"
}


function splash () {
    echo -ne "\n";
    echo -ne "****************** === *************************\n"
    echo -ne "${BBlue}[$FUNCNAME]${NC}:\t" "${@}" "\n";
    echo -ne "****************** === *************************\n"
}

##  ------------------------------------------------------------------------  ##
##                             Timeout Helper                                 ##
##  ------------------------------------------------------------------------  ##

function Delay () {
    local T=1;
    printf "\nTimeout ${T} second(s) ... ";
    sleep T;
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
