##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

# .SILENT:

.EXPORT_ALL_VARIABLES:

# .IGNORE:
##  ------------------------------------------------------------------------  ##

APP_NAME := mp3web

REPO_HOST := "https://bitbucket.org"
REPO_USER := "tbaltrushaitis"
REPO_URL := "$(shell git ls-remote --get-url)"

# APP_REPO := "https://github.com/tbaltrushaitis/mp3web.git"
APP_REPO := ${REPO_HOST}/${REPO_USER}/${APP_NAME}.git
APP_ENV := $(shell cat .NODE_ENV)
CODE_VERSION := $(shell cat ./VERSION)
APP_BRANCH := "dev-1.0.2"

WD := $(shell pwd -P)
APP_DIRS := $(addprefix ${WD}/,build-* dist-*)
APP_SRC := "${WD}/src"
APP_BUILD := "${WD}/build"
APP_DIST := "${WD}/dist"

DT = $(shell date +'%Y%m%d%H%M%S')

RC_EXISTS := $(shell [ -e ./setup.rc ] && echo 1 || echo 0)

ifeq ($(RC_EXISTS), 1)
$(info [${DT}] Source definitions file [setup.rc] EXISTS)
include setup.rc
else
$(error [${DT}] Missing file [setup.rc])
endif

##  ------------------------------------------------------------------------  ##
DIR_ENGINE := ${WD}/${ENGINE_NAME}-${ENGINE_VERSION}
GIT_COMMIT := $(shell git rev-list --remove-empty --remotes --max-count=1 --date-order --reverse)

$(file > COMMIT,${GIT_COMMIT})

DIR_SRC := ${WD}/src
DIR_BUILD := ${WD}/build-${CODE_VERSION}
DIR_DIST := ${WD}/dist-${CODE_VERSION}
DIR_COMMIT := ${GIT_COMMIT}
DIR_WEB := ${WD}/webroot

##  ------------------------------------------------------------------------  ##
# Query the default goal.

ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
$(warning [${DT}] Default goal [1] is SET TO: [$(.DEFAULT_GOAL)])
else
$(info [${DT}] Default goal [2] is: [$(.DEFAULT_GOAL)])
endif

##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include ./bin/Makefile-utils.inc

##  ------------------------------------------------------------------------  ##

.PHONY: default
default: banner test state help

##  ------------------------------------------------------------------------  ##

$(info [${DT}] Default goal [3] is: [$(.DEFAULT_GOAL)])

.PHONY: test test_rc

test: test_rc

## SOURCE VARIABLES
test_rc: setup.rc
	@ echo "\n[${DT}] TEST GOAL EXECUTED";

help:
	@ echo "\n";
	@ echo "AVAILABLE COMMANDS:";
	@ echo "\t make clean \t - CLEAR directories and delete files";
	@ echo "\t make clone \t - CLONE project sources from provided repo";
	@ echo "\t make compile \t - BUILD sources";
	@ echo "\t make release \t - COMPILE project distro";
	@ echo "\t make deploy \t - DEPLOY compiled project to web directory";
	@ echo "\n";

##  ------------------------------------------------------------------------  ##

.PHONY: clone

clone:
	@  git clone -b ${APP_BRANCH} ${APP_REPO} 	\
	&& cd ${APP_NAME} 													\
	&& git pull																	\
	&& git branch											  				\
	&& find . -type f -exec chmod 664 {} \; 		\
	&& find . -type d -exec chmod 775 {} \; 		\
	&& find . -type f -name "*.sh" -exec chmod 755 {} \;

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
	@ cat BANNER

##  ------------------------------------------------------------------------  ##

.PHONY: clean clean-all
.PHONY: clean-repo clean-src
.PHONY: clean-build clean-dist clean-engine clean-web clean-files

clean-all: clean clean-web

clean: clean-build clean-dist clean-engine clean-files

clean-repo:
	@ rm -rf "${APP_NAME}"

clean-src:
	@ rm -rf "${DIR_SRC}"

clean-build:
	@ rm -rf "${DIR_BUILD}"

clean-dist:
	@ rm -rf "${DIR_DIST}"

clean-engine:
	@ rm -rf "${DIR_ENGINE}"

clean-web:
	@ rm -rf "${DIR_WEB}"

clean-files:
	@ rm -rf COMMIT 						\
	  bower_modules/						\
		node_modules/ 						\
		bitbucket-pipelines.yml		\
		codeclimate-config.patch	\
		_config.yml

##  ------------------------------------------------------------------------  ##

tree:
	@ ./setup.sh "tree"

##  ------------------------------------------------------------------------  ##

prep:
	@ ./setup.sh "prepare"

compile:
	@ ./setup.sh "compile"

release:
	@ ./setup.sh "release"

deploy:
	@ ./setup.sh "deploy"

# dev:
# 	@ NODE_ENV=development ./setup.sh "all"
# 	# @ NODE_ENV=development gulp

##  ------------------------------------------------------------------------  ##

##  ------------------------------------------------------------------------  ##

all: clean tree prep compile release deploy help

#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

.PHONY: all

##  ------------------------------------------------------------------------  ##
