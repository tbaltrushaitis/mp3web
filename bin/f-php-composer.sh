#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##              f-php-composer.sh: PHP COMPOSER setup and update              ##
##  ------------------------------------------------------------------------  ##
##  Provides:
##    composer_setup()
##    composer_selfupdate()
##    composer_check()
##  ------------------------------------------------------------------------  ##

function composer_setup {
  SIGNATURE_EXPECTED=$(wget http://composer.github.io/installer.sig -O - -q)
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  SIGNATURE_ACTUAL=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

  if [ "$SIGNATURE_EXPECTED" = "$SIGNATURE_ACTUAL" ]
  then
    printf "[OK]\tCorrect installer signature [$SIGNATURE_ACTUAL]\n"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
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
  info "[LOG]\tCOMPOSER UPDATED to $(composer -V)\n"
}


function composer_check {
  _composer=`which composer 2>&1`;
  if [ $? -ne 0 ]; then
    warn "Composer not found!";
    info "Starting composer setup from [http://getcomposer.org/] ... \n";
    composer_setup
    composer_selfupdate
    info "\t FINISHED composer setup. Please run $# again.\n";
    # exit 1
  fi
  printf "[OK]\t$(composer -V) Installed\n";
}

##  --------------------  EOF: f-php-composer.sh  --------------------------  ##
