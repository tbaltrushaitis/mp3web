### !/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  NPM and BOWER DEPENDENCIES
##  ------------------------------------------------------------------------  ##

##  Consists of:
##      deps_install
##      deps_outdated


##  ------------------------------------------------------------------------  ##

function deps_install {
    printf "[LOG]\tInstalling NPM packages ... \n";
    npm i --verbose

    printf "[LOG]\tInstalling Bower packages ... \n";
    bower i --verbose --production
}

function deps_outdated {
    bower list
    npm outdated
}

##  ------------------------------------------------------------------------  ##
