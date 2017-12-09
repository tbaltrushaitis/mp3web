# Web MP3 Player :headphones: and Media Library Manager #

<p align="center">
  <img src="src/resources/assets/img/logo/Favicon.png" alt="Web MP3 Player Logo">
</p>

`mp3` `web` `player` `audio` `library` `manager`

-----

## Badges ##

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)
[![Code Climate](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/gpa.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web)
[![Test Coverage](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/coverage.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web/coverage)

-----

## Components ##

 Scope | Role | Name | Version | Description
:-----:|:----:|:-----|:-------:|:------------
 Host | Engine | [Composer](https://getcomposer.org/) | 1.5.2 | Dependency Manager for PHP
 Back | Engine | [Laravel](https://laravel.com/docs/5.2) | 5.2.31 | PHP Framework
 Front | Framework | [Bootstrap](http://getbootstrap.com) | 3.3.7 | HTML, CSS, and JS framework
 Front | Plugin | [Bootstrap Tagsinput](https://github.com/bootstrap-tagsinput/bootstrap-tagsinput) | 0.8.0 | jQuery tags input plugin based on Twitter Bootstrap
 Front | Library | [requirejs](https://github.com/jrburke/requirejs) | 2.3.3 | A file and module loader for JavaScript
 Front | Library | [Font-Awesome](http://fontawesome.io/) | 4.7.0 | The iconic font and CSS toolkit
 Front | Library | [jQuery](http://jquery.com/) | 2.2.4 | JavaScript Library
 Front | Library | [Lodash](https://lodash.com/docs/4.17.4) | 4.17.4 | A modern JavaScript utility library delivering modularity, performance & extras.
 Front | Library | [animate.css](http://daneden.github.io/animate.css/) | 3.5.2 | A cross-browser library of CSS animations
 Front | DEPRECATED | [Underscore.js](http://underscorejs.org) | :x: | JavaScript library that provides a whole mess of useful functional programming helpers

## Live Demo ##
:point_right: [Premium Music Collection](http://mp3.gsm-center.com.ua)

-----

## Usage ##

### 1 - Download ###
```bash
$ git clone -b latest https://github.com/tbaltrushaitis/mp3web.git mp3web
```

### 2 - Configure ###
Open file `setup.rc` in your favourite editor and change values of build
variables in it (e.g. DB_HOST, APP_URL)

### 3 - Build ###

With `make` - GNU make utility to maintain groups of programs

In fact you just need to type in your terminal:
```bash
$ make
```

To get additional info and usage examples type `make usage|help` command param:
```bash
$ make help

AVAILABLE COMMANDS:
  make clean   - CLEAR directories and delete files;
  make setup   - check for php, nodejs and bower installations;
  make engine  - cook engine sources;
  make build   - BUILD project from sources;
  make release - COMPILE project distro;
  make deploy  - DEPLOY compiled project to web directory;
  make all     - Run all operations in their preferred order;
```

### 4 - Deploy ###
```bash
$ make all
```

### 5 - Enjoy ###


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

---------

## Todo List ##
 - [ ] Implement search throw items.

## Change log ##

### v1.0.2 ###
 - [x] Makefile scenario now used to build and deploy project
 - [x] Frontend components collected by **bower** task in gulpfile

### v1.0.1 ###
 - [x] Genre tags added as labels for track
 - [x] gulpfile.js scenario tasks improved
 - [x] setup.sh and setup.rc scripts used to simplify setup and build processes
 - [x] Documentation update
 - [x] Repository page look on github improved with logo image

### v1.0.0 ###
 - [x] Laravel 5.2 is now used as a backend framework
 - [x] Items that was uploaded in less than a week ago marked with "NEW" label
 - [x] Ability for visitors to register and become Users with access to private cabinet.
 - [x] Current playing item is moved on top of the list.
 - [x] Possibility to edit item properties from Admin Panel.

### v0.0.2 ###
 - [x] Added 'Plays' counter which indicates how many times track was listened

### v0.0.1: ###
 - [x] Add bower.json file
 - [x] Add package.json data
 - [x] Create directories tree structure

### v0.0.0 ###
 - [x] Initial release

--------

### Contributors ###

[![Contributors List](https://img.shields.io/github/contributors/tbaltrushaitis/mp3web.svg)](https://github.com/tbaltrushaitis/mp3web/graphs/contributors)

--------

### Useful Info ###

 - [GitHub / Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
 - [BitBucket Markdown Howto](https://bitbucket.org/tutorials/markdowndemo)
 - [Creating an Automated Build](https://docs.docker.com/docker-hub/builds/)
 - [Linking containers](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks.md)
 - [Cross-host linking containers](https://docs.docker.com/engine/admin/ambassador_pattern_linking.md)

--------
