# Web MP3 Player :headphones: and Media Library Manager

![Web MP3 Player Logo](src/resources/assets/img/logo/Favicon.png)

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)
[![Code Climate](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/gpa.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web)
[![Issue Count](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/issue_count.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web)
[![Test Coverage](https://codeclimate.com/github/tbaltrushaitis/mp3web/badges/coverage.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3web/coverage)

## Credits ##

 Name | Version | Description
------|---------|-------------
[Laravel](https://laravel.com/docs/5.2) | 5.2.0 | Framework
[Font-Awesome](http://fontawesome.io/) | 4.6.3 | The iconic font and CSS toolkit
[Bootstrap](http://getbootstrap.com) | 3.3.6 | HTML, CSS, and JS framework
[animate.css](http://daneden.github.io/animate.css/) | 3.5.2 | A cross-browser library of CSS animations
[jQuery](http://jquery.com/) | 2.2.4 | JavaScript Library
[requirejs](https://github.com/jrburke/requirejs) | 2.3.1 | A file and module loader for JavaScript
[Underscore.js](http://underscorejs.org) | 1.8.3 | JavaScript library that provides a whole mess of us
[Composer](https://getcomposer.org/) | :trident: | Dependency Manager for PHP


## Live Demo Site ##
:point_right: [Premium Music Collection](http://mp3.gsm-center.com.ua)

## Download ##
```sh
$ git clone https://github.com/tbaltrushaitis/mp3web.git mp3web && cd mp3web
```

## Configure ##
Open file `setup.rc` in your favourite editor and change values of build variables in it (e.g. DB_HOST, APP_URL)

## Build &amp; Deploy ##
Run the `setup.sh` script. In most cases it will do all of the needed stuff to run instance of Web MP3 Player app
```sh
$ ./setup.sh
```

## Actions in `setup.sh` script ##

### Check if those packages are installed and available in PATH ###
- [ ] Composer
- [ ] Node.js
- [ ] NPM
- [ ] Bower
- [ ] Gulp

## Gulp Tasks Overview ##

In common case gulp command should look like
```sh
$ gulp command:p1:..:pN --env_VAR=some_VALUE

# e.g.
# gulp build:css --env=production
# gulp bower:collect:fonts --env=production
# or
# gulp --env=dev
```

Below is a list of gulp tasks and their possible params:

 :hash: | Command | Task | Source | Target | Comment
---|---------|------|--------|--------|---------
 :information_source: | **show** | | | | Display information
  | | files:src | src/ | build/ | List of files
  | | usage | | | Show help topic
  | | show:config | .env | | Environment config
 :octocat: | **clean** | | | | Delete files and directories
  | | clean:build | | build/ | Reset build directory
  | | clean:dist | | dist/ | Reset release directory
 :+1: | **bower** | | | | Frontend modules manager
  | | bower:fonts | | | Collect fonts
  | | bower:css:fonts | | | Collect, merge and minify fonts CSS files
  | | bower:css:plugins | | | CSS files for plugins
  | | bower:js | | | Plugins itself
  | | bower:plugins | | | Plugins directories
 :twisted_rightwards_arrows: | **sync** | | | | Copy directories
  | | sync:engine | laravel-5.2/ | build/ | Framework
  | | sync:src | src/ | build/ | App source
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
 :rocket: | **deploy** | | | | Publish releases
 :white_check_mark: | **lint** | | | | Checks JavaScript for mistakes
  | | jscs | | | Code style linter and formatter
  | | jshint | | | Static Code Analysis Tool
 :restroom: | **watch** | | | | Detect files changes
  | | watch:src:views | | | Templates
  | | watch:src:css | | | Styles
  | | watch:src:js | | | Scripts
 :u5408: | **artisan** | | | | Laravel console commands

---------

## Todo List ##
- [ ] Implement search throw items.

## Change log ##

### v1.0.1: ###
- [x] Genre tags added as labels for track
- [x] gulpfile.js scenario tasks improved
- [x] setup.sh and setup.rc scripts used to simplify setup and build processes
- [x] Documentation update
- [x] Repository page look on github improved with logo image

### v1.0.0: ###
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


----------------
## And, just a few Emoji Icons ##
:musical_score: :musical_keyboard: :violin: :musical_note: :microphone: :star: :loudspeaker: :notes: :scorpius: :white_check_mark: :signal_strength: :dvd: :sound: :musical_note: :+1: :musical_keyboard: :saxophone: :violin: :musical_score: :headphones: :notes: :headphones: :trumpet: :saxophone: :guitar: 
----------------
