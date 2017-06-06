# Web MP3 Player :headphones: and Media Library Manager

![Web MP3 Player Logo](src/resources/assets/img/logo/Favicon.png)

## Badges

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)
[![Code Climate](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/gpa.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web)
[![Test Coverage](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/coverage.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web/coverage)

## Credits ##

 Name | Version | Description
:-----|:-------:|:------------
[animate.css](http://daneden.github.io/animate.css/) | 3.5.2 | A cross-browser library of CSS animations
[Bootstrap](http://getbootstrap.com) | 3.3.7 | HTML, CSS, and JS framework
[Bootstrap Tagsinput](https://github.com/bootstrap-tagsinput/bootstrap-tagsinput) | 0.8.0 | jQuery tags input plugin based on Twitter Bootstrap
[Composer](https://getcomposer.org/) | :trident: | Dependency Manager for PHP
[Font-Awesome](http://fontawesome.io/) | 4.7.0 | The iconic font and CSS toolkit
[jQuery](http://jquery.com/) | 2.2.4 | JavaScript Library
[Laravel](https://laravel.com/docs/5.2) | 5.2.31 | Framework
[requirejs](https://github.com/jrburke/requirejs) | 2.3.3 | A file and module loader for JavaScript
[Underscore.js](http://underscorejs.org) | 1.8.3 | JavaScript library that provides a whole mess of us


## Live Demo Site ##
:point_right: [Premium Music Collection](http://mp3.gsm-center.com.ua)

## Getting started ##

### Clone from github ###
```bash
$ git clone -b latest https://github.com/tbaltrushaitis/mp3web.git mp3web
```

### Set file permissions ###
```bash
$ WEB_USER="$(whoami)"
$ sudo chmod 775 mp3web
$ cd mp3web
$ sudo chown -R ${WEB_USER}:${WEB_USER} * && sudo chown -R ${WEB_USER}:${WEB_USER} .*
$   sudo find . -type f -exec chmod 664 {} \; \
 && sudo find . -type d -exec chmod 775 {} \; \
 && sudo find . -type f -name *.sh -exec sudo chmod a+x {} \;
```

### Configure ###
Open file `setup.rc` in your favourite editor and change values of build variables in it (e.g. DB_HOST, APP_URL)

## Build and Deploy ##

 - With NPM

 - Advanced users may want to use directly `setup.sh` script directives.
   In most cases running this script with **all** parameter will do all of the needed stuff to run instance of Web MP3 Player application
```bash
$ ./setup.sh all
```

### Actions in `setup.sh` script ###

#### It will check if those packages are installed and available in PATH: ####
- [x] Composer
- [x] Node.js
- [x] NPM
- [x] Bower
- [x] Gulp

## Gulp Tasks Overview ##

In common case gulp command should look like
```bash
$ gulp command:p1:..:pN --env_VAR=some_VALUE

# e.g.
# gulp bower --env=production
# gulp build --env=production
# or
# gulp --env=dev
```

Below is a list of gulp tasks and their possible params:

 :hash: | Task | Source | Target | Comment
:------:|:-----|:------:|:------:|:--------
| :one: | **show** | | | Display information
| | usage | | | Show help topic
| | show:config | .env | | Environment configuration
| | files:src | src/ | build/ | List of changed files
| :two: | **clean** | | | | Delete files and directories
| | clean:build | | build/ | Reset build directory
| | clean:dist | | dist/ | Reset release directory
 :three: | **bower** | | | Frontend modules manager
| | bower:collect | bower_modules/ | resources/assets/ | Collect js, css, fonts and images from bower packages
| :four: | **sync** | | | Copy directories
| | sync:engine | laravel-*/ | build/ | Framework Original Sources
| | sync:src | src/ | build/ | Application sources
| | sync:assets | build/resources/assets/ | build/public/assets/ | Build Assets to public
| | sync:assets:css | src/resources/assets/css/ | build/resources/assets/css/ | 
| | sync:assets:media | build/resources/assets/img/ | build/public/assets/img/ | Build Images to public
| | sync:assets:fonts | | | 
| | sync:assets:js | | | 
| | sync:views | | | 
| | sync:dist | build/ | dist/ | Create release directory from BUILD
| | sync:web | build/ | webroot/ | Create/update public web directory
| :five: | **build** | | | Build package
| | build | | dist/ | Production package
| | build:dev | | build/ | Development stage test package
| :six: | **deploy** | | | Publish releases
| :seven: | **lint** | | | Checks JS and CSS files for mistakes
| | jscs | | | Code style linter and formatter
| | jshint | | | Static Code Analysis Tool
| :eight: | **watch** | | | Detect files changes
| | watch:src:views | | | Templates
| | watch:src:css | | | Styles
| | watch:src:js | | | Scripts
| :nine: | **artisan** | | | Laravel console commands
| :unlock:| fixPermissions | | build/ | Set owner of files to webserver user

---------

:bangbang: Below is a list of outdated gulp tasks:

 :hash: | Task | Source | Target | Comment
:------:|:-----|:------:|:------:|:--------
| :x: | bower:fonts | | | Collect fonts
| :x: | bower:css:fonts | | | Collect, merge and minify fonts CSS files
| :x: | bower:css:plugins | | | CSS files for plugins
| :x: | bower:js | | | Plugins itself
| :x: | bower:plugins | | | Plugins directories
| :x: | sync:web:dev | | | Create/update development web directory

---------

## Todo List ##
[ ] Implement search throw items.

## Change log ##

### v1.0.2: ###

### v1.0.1: ###
[x] Genre tags added as labels for track
[x] gulpfile.js scenario tasks improved
[x] setup.sh and setup.rc scripts used to simplify setup and build processes
[x] Documentation update
[x] Repository page look on github improved with logo image

### v1.0.0: ###
 [x] Laravel 5.2 is now used as a backend framework
 [x] Items that was uploaded in less than a week ago marked with "NEW" label
 [x] Ability for visitors to register and become Users with access to private cabinet.
 [x] Current playing item is moved on top of the list.
 [x] Possibility to edit item properties from Admin Panel.

### v0.0.2: ###
 [x] Added 'Plays' counter which indicates how many times track was listened

### v0.0.1: ###
 [x] Add bower.json file
 [x] Add package.json data
 [x] Create directories tree structure

### v0.0.0: ###
 [x] Initial release

--------

### Authors and Contributors ###

##### DevTeam #####
  + @tbaltrushaitis

##### Contributors #####

[![GitHub Contributors](https://img.shields.io/github/contributors/tbaltrushaitis/mp3web.svg)](https://github.com/tbaltrushaitis/mp3web/graphs/contributors)

--------

### Useful Info ###

 - [GitHub / Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
 - [BitBucket Markdown Howto](https://bitbucket.org/tutorials/markdowndemo)
 - [Creating an Automated Build](https://docs.docker.com/docker-hub/builds/)
 - [Linking containers](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks.md)
 - [Cross-host linking containers](https://docs.docker.com/engine/admin/ambassador_pattern_linking.md)

--------
