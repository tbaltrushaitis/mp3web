# Web MP3 Player

![Web MP3 Player Logo](src/resources/assets/img/logo/Favicon.png)

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)
[![Code Climate](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/gpa.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3)
[![Issue Count](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/issue_count.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3)
[![Test Coverage](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/coverage.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3/coverage)


## Demo
[Premium Music Collection](http://mp3.gsm-center.com.ua)

:star: :notes: :scorpius: :white_check_mark: :signal_strength: :dvd: :sound: :musical_note: :+1: :musical_keyboard: :saxophone: :violin: :musical_score: :headphones: 

## Credits

 Name | Version | Description
------|---------|-------------
[Laravel](https://laravel.com/docs/5.2) | 5.2.0 | Framework
[Font-Awesome](http://fontawesome.io/) | 4.6.3 | The iconic font and CSS toolkit
[Bootstrap](http://getbootstrap.com) | 3.3.6 | HTML, CSS, and JS framework
[animate.css](http://daneden.github.io/animate.css/) | 3.5.2 | A cross-browser library of CSS animations
[jQuery](http://jquery.com/) | 2.2.4 | JavaScript Library
[requirejs](https://github.com/jrburke/requirejs) | 2.3.1 | A file and module loader for JavaScript
[Underscore.js](http://underscorejs.org) | 1.8.3 | JavaScript library that provides a whole mess of us


## Download ##
```bash
$ git clone https://github.com/tbaltrushaitis/mp3.git mp3 && cd mp3
$ composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
$ cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd ..
$ npm i && bower i
```

## Gulp Tasks Overview ##

In common case gulp command should look like `gulp command:p1:..:pN`.
Here is a list of tasks and possible params:

 # | Command | Task | Source | Target | Comment
---|---------|------|--------|--------|---------
 :id: | **show** | | | | Display information
  | | files:src | | | List of files
  | | show:usage | | | Show help topic
  | | show:config | config.json | | Output config file content into console
 :octocat: | **clean** | | | | Delete files and directories
  | | clean:build | | build/ | Reset build directory
  | | clean:dist | | dist/ | Reset release directory
  | | clean:resources | | build/resources/ \
                          webroot/resources  | Assets files removal
  | | clean:public | | build/public/assets/ | Webroot directory
 :+1: | **bower** | | | | Frontend modules manager
  | | bower:fonts | | | Collect fonts
  | | bower:css:fonts | | | Collect, merge and minify fonts CSS files
  | | bower:css:plugins | | | CSS files for plugins
  | | bower:js | | | Plugins itself
  | | bower:plugins | | | Plugins directories
 :dancers: | **sync** | | | | Copy directories
  | | sync:engine | laravel-5.2/ | build/ | Laravel installation
  | | sync:src | src/ | build/ | Code sources to Build
  | | sync:assets | build/resources/assets/ | build/public/assets/ | Build Assets to public
  | | sync:assets:css | src/resources/assets/css/ | build/resources/assets/css/ | 
  | | sync:assets:media | build/resources/assets/img/ | build/public/assets/img/ | Build Images to public
  | | sync:assets:fonts | | | 
  | | sync:assets:js | | | 
  | | sync:views | | | 
  | | sync:dist | | | 
  | | sync:web | | | 
  | | sync:web:dev | | | 
 :package: | **build** | | | | Build sources
  | | build | | | Production package
  | | build:dev | | | Test package
 :white_check_mark: | **deploy** | | | | Publish releases
 :checkered_flag: | **lint** | | | | Checks JavaScript for mistakes
  | | jscs | | | 
  | | jshint | | | 
 :watch: | **watch** | | | | Detect files changes
  | | watch:src:views | | | Templates
  | | watch:src:css | | | Styles
  | | watch:src:js | | | Scripts
 :on: | **artisan** | | | | Laravel console commands

---------

## Todo List ##
- [ ] Implement search throw items.

## Change log ##

### v1.0.1:
- [x] Genre tags added as labels for track
- [x] gulpfile.js scenario tasks improved
- [x] setup.sh and setup.rc scripts used to simplify setup and build processes
- [x] Documentation update
- [x] Repository page look on github improved with logo image

### v1.0.0:
- [x] Laravel 5.2 is now used as a backend framework
- [x] Items that was uploaded in less than a week ago marked with "NEW" label
- [x] Ability for visitors to register and become Users with access to private cabinet.
- [x] Current playing item is moved on top of the list.
- [x] Possibility to edit item properties from Admin Panel.

**v0.0.2:**
- [x] Added 'Plays' counter which indicates how many times track was listened

**v0.0.1:**
- [x] Add bower.json file
- [x] Add package.json data
- [x] Create directories tree structure

**v0.0.0:**
- [x] Initial release
