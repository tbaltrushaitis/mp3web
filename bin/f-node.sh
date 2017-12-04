#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  NPM and BOWER DEPENDENCIES
##  ------------------------------------------------------------------------  ##

##  Provides:
##    deps_install()
##    deps_outdated()

##  ------------------------------------------------------------------------  ##

function deps_install {
  warn "\tInstalling NPM packages ... ";
  npm i #--verbose

  warn "\tInstalling Bower packages ... ";
  bower i --production --allow-root #--verbose
}

function deps_outdated {
  bower list
  npm outdated
}

##  ------------------------------------------------------------------------  ##
