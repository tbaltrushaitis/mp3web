#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##  PHP COMPOSER
##  ------------------------------------------------------------------------  ##
##  - Install php composer

##  Consists of:
##      composer_setup
##      composer_selfupdate
##      check_composer

function composer_setup {
  SIGNATURE_EXPECTED=$(wget http://composer.github.io/installer.sig -O - -q)
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  SIGNATURE_ACTUAL=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

  if [ "$SIGNATURE_EXPECTED" = "$SIGNATURE_ACTUAL" ]
  then
    printf "[OK]\tCorrect installer signature [$SIGNATURE_ACTUAL]\n"
    sudo php composer-setup.php --install-dir=/bin --filename=composer
    RESULT=$?
    mv composer-setup.php composer-setup-DONE-$(date +"%s").php
    printf "[LOG]\tCOMPOSER INSTALL FINISHED\n"
    # exit $RESULT
  else
    >&2 printf '[ERROR]\tInvalid installer signature\n'
    mv composer-setup.php composer-setup-INVALID-$(date +"%s").php
    exit 1
  fi
}


function composer_selfupdate {
  composer -vvv selfupdate
  printf "[LOG]\tCOMPOSER UPDATED to $(composer -V)\n"
}


function check_composer {
  # _composer=`which composer 2>&1`
  # if [ $? -ne 0 ]; then
    # printf "[WARNING]\tComposer not found!\n";
    printf "[INFO]\thttp://getcomposer.org/\n";
    printf "[LOG]\tStarting composer setup ... \n";
    composer_setup
    composer_selfupdate
    printf "[INFO]\tPlease run $# again.\n";
    # exit 1
  # fi
  printf "[OK]\t$(composer -V) Installed\n";
}

##  --------------------  EOF: f-php-composer.sh  --------------------------  ##
