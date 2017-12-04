#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##            host-checks.sh: Test variables, packages, etc                   ##
##  ------------------------------------------------------------------------  ##

##  Provides:
##    okNode()
##    okNpm()
##    okBower()
##    okGulp()
##    okGrunt()

##  ------------------------------------------------------------------------  ##
##                                  NODEJS                                    ##
##  ------------------------------------------------------------------------  ##

function okNode () {
  # info "------------------->>> " $FUNCNAME "(" $1 ")" " <<<-------------------";
  _node=`which node 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[ERROR]\tPlease install Node.js";
    error "[INFO]\thttp://nodejs.org/";
    exit 1
  fi
  warn "[OK]\tNODEJS $(node -v) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                   NPM                                      ##
##  ------------------------------------------------------------------------  ##

function okNpm () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _npm=`which npm 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[ERROR]\tPlease install NPM";
    exit 1
  fi
  warn "[OK]\tNPM v$(npm -v) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                  BOWER                                     ##
##  ------------------------------------------------------------------------  ##

function okBower () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _bower=`which bower 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[WARN]\tBower NOT FOUND!";
    warn "[INFO]\tInstalling Bower ... ";
    npm i -g bower
    if [ $? -ne 0 ]; then
      fatal "FAILED";
      exit 1
    fi
    printf "SUCCESS\n";
  fi
  warn "[OK]\tBOWER v$(bower -v --allow-root) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                  GULP                                      ##
##  ------------------------------------------------------------------------  ##

function okGulp () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _gulp=`which gulp 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[ERROR] Gulp NOT FOUND!";
    warn "[INFO] Installing gulp ... ";
    npm i -g gulp
    if [ $? -ne 0 ]; then
      fatal "FAILED";
      exit 1
    fi
    info "SUCCESS";
  fi
  warn "[OK] GULP Installed: $(gulp -v)";
}

##  ------------------------------------------------------------------------  ##
##                                  GRUNT                                     ##
##  ------------------------------------------------------------------------  ##

function okGrunt () {
  # info "------------------->>> " $FUNCNAME "(" $1 ")" " <<<-------------------";
  _grunt=`which grunt 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[ERROR]\tGrunt NOT FOUND!";
    warn "[INFO]\tInstalling grunt ... ";
    npm i -g grunt-cli
    if [ $? -ne 0 ]; then
      fatal "FAILED";
      exit 1
    fi
    info "SUCCESS";
  fi
  warn "[OK]\tGRUNT Installed:\n$(grunt -V)";
}
