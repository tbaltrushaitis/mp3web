#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  NPM and BOWER DEPENDENCIES
##  ------------------------------------------------------------------------  ##

##  Provides:
##    deps_install()
##    deps_outdated()

##  ------------------------------------------------------------------------  ##

function deps_install {
  info "\tInstalling NPM packages ... \n";
  npm i #--verbose

  info "\tInstalling Bower packages ... \n";
  bower i --production --allow-root #--verbose
}

function deps_outdated {
  bower list
  npm outdated
}

##  ------------------------------------------------------------------------  ##
