### !/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  NPM and BOWER DEPENDENCIES
##  ------------------------------------------------------------------------  ##


function deps_install {
    printf "[LOG]\tInstalling required NPM packages ... \n";
    npm i -verbose

    printf "[LOG]\tInstalling required Bower packages ... \n";
    bower i --verbose
}


function deps_outdated {
    bower list
    npm outdated
}

