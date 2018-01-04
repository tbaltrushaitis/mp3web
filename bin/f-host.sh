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
    fatal "[$FUNCNAME] [ERROR] Please install Node.js";
    warn "[$FUNCNAME] [INFO] http://nodejs.org/";
    exit 1
  fi
  warn "[$FUNCNAME] [OK] NODEJS $(node -v) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                   NPM                                      ##
##  ------------------------------------------------------------------------  ##

function okNpm () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _npm=`which npm 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[$FUNCNAME] [ERROR] Please install NPM";
    exit 1
  fi
  warn "[$FUNCNAME] [OK] NPM v$(npm -v) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                  BOWER                                     ##
##  ------------------------------------------------------------------------  ##

function okBower () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _bower=`which bower 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[$FUNCNAME] [WARN] Bower NOT FOUND!";
    warn "[$FUNCNAME] [INFO] Installing Bower ... ";
    npm i -g bower
    if [ $? -ne 0 ]; then
      fatal "[$FUNCNAME] FAILED";
      exit 1
    fi
    info "[$FUNCNAME] SUCCESS";
  fi
  warn "[$FUNCNAME] [OK] BOWER v$(bower -v --allow-root) Installed";
}

##  ------------------------------------------------------------------------  ##
##                                  GULP                                      ##
##  ------------------------------------------------------------------------  ##

function okGulp () {
  # info "\n----------------->>> " $FUNCNAME "(" $1 ")" " <<<-----------------\n";
  _gulp=`which gulp 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[$FUNCNAME] [ERROR] Gulp NOT FOUND!";
    warn "[$FUNCNAME] [INFO] Installing gulp ... ";
    npm i -g gulp
    if [ $? -ne 0 ]; then
      fatal "[$FUNCNAME] FAILED";
      exit 1
    fi
    info "[$FUNCNAME] SUCCESS";
  fi
  warn "[$FUNCNAME] [OK] GULP Installed: $(gulp -v)";
}

##  ------------------------------------------------------------------------  ##
##                                  GRUNT                                     ##
##  ------------------------------------------------------------------------  ##

function okGrunt () {
  # info "------------------->>> " $FUNCNAME "(" $1 ")" " <<<-------------------";
  _grunt=`which grunt 2>&1`
  if [ $? -ne 0 ]; then
    fatal "[$FUNCNAME] [ERROR] Grunt NOT FOUND!";
    warn "[$FUNCNAME] [INFO] Installing grunt ... ";
    npm i -g grunt-cli
    if [ $? -ne 0 ]; then
      fatal "[$FUNCNAME] FAILED";
      exit 1
    fi
    info "[$FUNCNAME] SUCCESS";
  fi
  warn "[$FUNCNAME] [OK] GRUNT Installed: $(grunt -V)";
}
