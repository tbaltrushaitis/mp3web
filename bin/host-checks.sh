#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##            host-checks.sh: Test variables, packages, etc                   ##
##  ------------------------------------------------------------------------  ##

##  Consists of:
##      okNode
##      okNpm
##      okBower
##      okGulp
##      okGrunt

##  ------------------------------------------------------------------------  ##
##                                  NODEJS                                    ##
##  ------------------------------------------------------------------------  ##

function okNode () {
    # info "\n--------------------->>> " $FUNCNAME "(" $1 ")" " <<<---------------------\n";
    _node=`which node 2>&1`
    if [ $? -ne 0 ]; then
        printf "[ERROR]\tPlease install Node.js\n";
        printf "[INFO]\thttp://nodejs.org/\n";
        exit 1
    fi
    printf "[OK]\tNODEJS $(node -v) Installed\n";
}

##  ------------------------------------------------------------------------  ##
##                                  NPM                                       ##
##  ------------------------------------------------------------------------  ##

function okNpm () {
    # info "\n--------------------->>> " $FUNCNAME "(" $1 ")" " <<<---------------------\n";
    _npm=`which npm 2>&1`
    if [ $? -ne 0 ]; then
        printf "[ERROR]\tPlease install NPM\n";
        exit 1
    fi
    printf "[OK]\tNPM v$(npm -v) Installed\n";
}

##  ------------------------------------------------------------------------  ##
##                                  BOWER                                     ##
##  ------------------------------------------------------------------------  ##

function okBower () {
    # info "\n--------------------->>> " $FUNCNAME "(" $1 ")" " <<<---------------------\n";
    _bower=`which bower 2>&1`
    if [ $? -ne 0 ]; then
        printf "[WARN]\tBower NOT FOUND!\n";
        printf "[INFO]\tInstalling Bower ... ";
        npm i -g bower
        if [ $? -ne 0 ]; then
            printf "FAILED\n";
            exit 1
        fi
        printf "SUCCESS\n";
    fi
    printf "[OK]\tBOWER v$(bower -v --allow-root) Installed\n";
}

##  ------------------------------------------------------------------------  ##
##                                  GULP                                      ##
##  ------------------------------------------------------------------------  ##

function okGulp () {
    # info "\n--------------------->>> " $FUNCNAME "(" $1 ")" " <<<---------------------\n";
    _gulp=`which gulp 2>&1`
    if [ $? -ne 0 ]; then
        printf "[ERROR]\tGulp NOT FOUND!\n";
        printf "[INFO]\tInstalling gulp ... ";
        npm i -g gulp
        if [ $? -ne 0 ]; then
            printf "FAILED\n";
            exit 1
        fi
        printf "SUCCESS\n";
    fi
    printf "[OK]\tGULP Installed:\n$(gulp -v) \n";
}

##  ------------------------------------------------------------------------  ##
##                                  GRUNT                                     ##
##  ------------------------------------------------------------------------  ##

function okGrunt () {
    # info "\n--------------------->>> " $FUNCNAME "(" $1 ")" " <<<---------------------\n";
    _grunt=`which grunt 2>&1`
    if [ $? -ne 0 ]; then
        printf "[ERROR]\tGrunt NOT FOUND!\n";
        printf "[INFO]\tInstalling grunt ... ";
        npm i -g grunt-cli
        if [ $? -ne 0 ]; then
            printf "FAILED\n";
            exit 1
        fi
        printf "SUCCESS\n";
    fi
    printf "[OK]\tGRUNT Installed:\n$(grunt -V) \n";
}

