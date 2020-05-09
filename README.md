[![Standard Version](https://img.shields.io/badge/release-standard%20version-brightgreen.svg?style=plastic)](https://github.com/conventional-changelog/standard-version)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://tbaltrushaitis.mit-license.org/)

# Web MP3 Player :headphones: and Media Library Manager #

<p align="center">
  <img src="src/resources/assets/img/logo/Favicon.png" alt="Web MP3 Player Logo" />
</p>

`mp3` `web` `player` `audio` `library` `manager`

---

## Live Demo ##
:point_right: [Premium Music Collection](http://bit.ly/mp3web) :point_left:

---

## :octocat: Credits ##

| Scope | Role | Name | Version | Description
|:-----:|:----:|:-----|:-------:|:------------
| Host | Installer | [Composer](https://getcomposer.org/) | 1.6.3 | Dependency Manager for PHP
| Back | Engine | [Laravel](https://laravel.com/docs/5.5) | 5.5.49 | PHP Framework
| Front | Library | [require.js](https://github.com/jrburke/requirejs) | 2.3.6 | A file and module loader for JavaScript
| Front | Library | [jQuery](http://jquery.com/) | 3.5.1 | JavaScript Library
| Front | Library | [Lodash](https://lodash.com/docs/4.17.15) | 4.17.15 | A modern JavaScript utility library delivering modularity, performance & extras.
| Front | Framework | [Bootstrap](http://getbootstrap.com) | 3.3.7 | HTML, CSS, and JS framework
| Front | Library | [Font-Awesome](http://fontawesome.io/) | 4.7.0 | The iconic font and CSS toolkit
| Front | Library | [Noty](https://ned.im/noty/#/) | 2.4.1 | A Dependency-free notification library
| Front | Library | [animate.css](http://daneden.github.io/animate.css/) | 3.7.2 | A cross-browser library of CSS animations
| Front | Plugin | [Bootstrap&nbsp;Tagsinput](https://github.com/bootstrap-tagsinput/bootstrap-tagsinput) | 0.8.0 | jQuery tags input plugin based on Twitter Bootstrap

---

## Usage ##

### 1 - Download ###
```shell
$ git clone -b latest https://github.com/tbaltrushaitis/mp3web.git && cd mp3web
```

### 2 - Configure ###
Edit file `src/.env.rc` (or create your own, e.g. `src/.env.rc.local`) - change values of build
variables in it (e.g. DB_HOST, APP_URL, etc.)

### 3 - Build ###

With `make` - GNU make utility to maintain groups of programs

In fact you just need to type in your terminal:
```shell
$ make
```

To get additional info and usage examples type `make usage|help|list` command:
```shell
$ make help
          ┌─────────────────────────────────────────────────┐
          │   __  __ _____ ______          ________ ____    │
          │  |  \/  |  __ \___ \ \        / /  ____|  _ \   │
          │  | \  / | |__) |__) \ \  /\  / /| |__  | |_) |  │
          │  | |\/| |  ___/|__ < \ \/  \/ / |  __| |  _ <   │
          │  | |  | | |    ___) | \  /\  /  | |____| |_) |  │
          │  |_|  |_|_|   |____/   \/  \/   |______|____/   │
          │                                                 │
          └─────────────────────────────────────────────────┘

---------------------------------------------------------
Available commands:
make
  list        - LIST all targets defined in this makefile
  clean       - CLEAR directories and delete files
  setup       - check for php, node and bower installations
  engine      - setup and build engine
  build       - BUILD project from sources
  release     - COMPILE project distro
  deploy      - DEPLOY compiled project to "webroot" directory
  all         - Run all operations for current stage from NODE_ENV file
  rebuild     - Execute [build, release, deploy] tasks
  redeploy    - Execute [release, deploy] tasks
---------------------------------------------------------
```

### 4 - Deploy ###
```shell
$ make all
```

### 5 - Enjoy ###

---

## Directory structure ##

```
.
├── .bowerrc              --> bower configuration
├── .gitattributes        --> git editor settings
├── .gitconfig            --> git client settings
├── .gitignore            --> specifies untracked files to git
├── .gitmodules           --> git submodules definition
├── .jshintignore         --> specifies untracked files to jshint
├── .npmrc                --> npm settings
├── bower.json            --> specified third party libs & dependencies for frontend application
├── gulpfile.js           --> configuration for gulp tasks
├── Makefile              --> main orchestration scenario
├── package.json          --> main project description file used by npm
├── README.md             --> this file
├── config                --> project configuration files
├── dist                  --> compiled project
├── node_modules          --> node modules
├── src                   --> application sources
│   ├── app               --> core code of server-side application
│   │   ├── Classes       --> project classes and objects
│   │   ├── Console       --> custom Artisan commands
│   │   ├── Events        --> houses event classes
│   │   ├── Exceptions    --> exception handler and is also a good place to hold any exceptions thrown by application
│   │   ├── Http          --> controllers, middleware, and form requests
│   │   ├── Jobs          --> TBD
│   │   ├── Listeners     --> N/A
│   │   ├── Mail          -->
│   │   ├── Notifications -->
│   │   ├── Policies      -->
│   │   ├── Providers     -->
│   │   ├── Rules         -->
│   │   ├── Repositories  -->
│   │   ├── Common        --> common factories, services, directives, filters, helpers for all project
│   ├── bootstrap         --> files which bootstraps the framework
│   ├── config            --> application configuration files
│   ├── database          --> database migrations, model factories, and seeds
│   ├── public            --> entry point for all requests entering your application
│   ├── resources         --> contains views as well as raw, un-compiled assets such as LESS, SASS, or JavaScript
|   │   ├── assets        --> folder for application assets
|   │   │   ├──fonts      --> folder for application fonts
|   │   │   ├──i18n       --> internationalization
|   │   │   ├──img        --> folder for application images
|   │   │   ├──css        --> application stylesheets and theme settings
|   │   │   ├──js         --> javascript files
|   │   │      ├──app     --> application scripts
|   │   │      ├──lib     --> third party libs
|   │   ├── views         --> raw Blade templates
│   ├── routes            --> route definitions for application
│   ├── storage           --> compiled Blade templates, sessions, caches, and other files generated by the framework
│   ├── tests             --> automated tests
│   ├── vendor            --> contains Composer dependencies
```

---

## TODO List ##

 - [ ] Implement search through items.

## CHANGELOG ##

See [Changelog file][Changelog] for details

---

### :link: More Info ###

 - [GitHub / Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
 - [BitBucket Markdown Howto](https://bitbucket.org/tutorials/markdowndemo)
 - [Creating an Automated Build](https://docs.docker.com/docker-hub/builds/)
 - [Linking containers](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks.md)
 - [Cross-host linking containers](https://docs.docker.com/engine/admin/ambassador_pattern_linking.md)

---

> :calendar: Developed on **11th of September 2016**

:scorpius:

[Changelog]: CHANGELOG.md
