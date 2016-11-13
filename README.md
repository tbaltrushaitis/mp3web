# Web MP3 Player

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)
[![Code Climate](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/gpa.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3)
[![Issue Count](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/issue_count.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3)
[![Test Coverage](https://codeclimate.com/github/tbaltrushaitis/mp3/badges/coverage.svg)](https://codeclimate.com/github/tbaltrushaitis/mp3/coverage)

## Demo
[Premium Music Collection](http://mp3.gsm-center.com.ua)

## Credits

* Laravel [5.2](https://laravel.com/docs/5.2) Framework
* Font-Awesome [4.6.3](http://fontawesome.io/) - The iconic font and CSS toolkit
* Bootstrap [3.3.6](http://getbootstrap.com) - HTML, CSS, and JS framework
* animate.css [3.5.2](http://daneden.github.io/animate.css/) - A cross-browser library of CSS animations
* jQuery [2.2.4](http://jquery.com/) - JavaScript Library
* requirejs [2.3.1](https://github.com/jrburke/requirejs) - A file and module loader for JavaScript
* Underscore.js [1.8.3](http://underscorejs.org) - JavaScript library that provides a whole mess of us


## Getting Started ##
```bash
$ git clone https://github.com/tbaltrushaitis/mp3.git mp3 && cd mp3
$ composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
$ cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd ..
$ npm i && bower i
```

---------

## Todo List ##
- [ ] Implement search throw items.
- [x] Highlight recently added items.
- [x] Create gulpfile.js scenario for automated builds

## Change log ##

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
