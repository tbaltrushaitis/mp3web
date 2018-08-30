##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

SHELL = /bin/sh

##  ------------------------------------------------------------------------  ##

# APP_NAME := mp3web
APP_SLOG := MP3WEB
APP_LOGO := ./assets/BANNER

APP_ENV := $(shell cat ./NODE_ENV)
APP_BANNER := $(shell cat ${APP_LOGO})

CODE_VERSION := $(shell cat ./VERSION)
GIT_COMMIT := $(shell git rev-list --remove-empty --remotes --max-count=1 --date-order --reverse)

WD := $(shell pwd -P)
DT = $(shell date +'%Y-%m-%dT%H:%M:%S %Z')

include ./bin/Colors.mk

##  ------------------------------------------------------------------------  ##

# REPO_HOST := https://bitbucket.org
# REPO_USER := tbaltrushaitis
REPO_URL := $(shell git ls-remote --get-url)

# APP_REPO := $(shell git ls-remote --get-url)
# APP_REPO := ${REPO_HOST}/${REPO_USER}/${APP_NAME}.git
# APP_BRANCH := dev-1.0.2
# DIR_COMMIT := ${GIT_COMMIT}

##  ------------------------------------------------------------------------  ##

COMMIT_EXISTS := $(shell [ -e COMMIT ] && echo 1 || echo 0)
ifeq ($(COMMIT_EXISTS), 0)
$(file > COMMIT,${GIT_COMMIT})
$(warning [${Cyan}${DT}${NC}] Created file [${BYellow}COMMIT${NC}:${BPurple}${GIT_COMMIT}${NC}])
endif

RC_FILE := ./src/.env.rc
RC_EXISTS := $(shell [ -e ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS), 0)
$(warning [${Cyan}${DT}${NC}]${BRed} Missing file: [${BYellow}${RC_FILE}${NC}])
exit 1
endif

include ${RC_FILE}

##  ------------------------------------------------------------------------  ##

DIR_ENGINE := engine/${ENGINE_NAME}-${ENGINE_VERSION}

DIR_SRC := ${WD}/src
DIR_BUILD := ${WD}/build-${CODE_VERSION}
DIR_DIST := ${WD}/dist-${CODE_VERSION}
DIR_WEB := ${WD}/webroot

APP_DIRS := $(addprefix ${WD}/,build-* dist-* webroot)

##  ------------------------------------------------------------------------  ##
# Query the default goal.

ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
$(info [${Cyan}${DT}${NC}] ${BYellow}.DEFAULT_GOAL${NC} [1] is SET TO: [${BPurple}$(.DEFAULT_GOAL)${NC}])
endif

##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include ./bin/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: default
default: banner test state help;

##  ------------------------------------------------------------------------  ##

# $(info [${Cyan}${DT}${NC}] ${BYellow}Default goal is: [${BPurple}$(.DEFAULT_GOAL)${NC}]);

.PHONY: test test_rc

test: test_rc;

## SOURCE VARIABLES
test_rc: ${DIR_SRC}/.env.rc ;
	@ echo [${Cyan}${DT}${NC}] ${BYellow}EXECUTING TEST GOAL${NC}

##  ------------------------------------------------------------------------  ##

.PHONY: clone

clone:
	# @  git clone -b ${APP_BRANCH} ${APP_REPO} ${APP_NAME} \
	@  git clone ${APP_REPO} ${APP_NAME} \
	&& cd ${APP_NAME} \
	&& git pull \
	&& find . -type f -exec chmod 664 {} \; \
	&& find . -type d -exec chmod 775 {} \; \
	&& find . -type f -name "*.sh" -exec chmod 755 {} \;

##  ------------------------------------------------------------------------  ##

.PHONY: deps deps-init deps-update

deps: deps-init deps-update

deps-init:
	@ git submodule add -b ${ENGINE_VERSION} --name engine/laravel --force -- https://github.com/laravel/laravel.git engine/
	@ git submodule init

deps-update:
	@ git submodule update --init --recursive

##  ------------------------------------------------------------------------  ##

.PHONY: tree

tree:
	@ ./setup.sh tree

##  ------------------------------------------------------------------------  ##

.PHONY: setup engine build build-engine build-assets release deploy

setup:
	@ ./setup.sh setup

# engine: engine_check ;
	# @ ./setup.sh engine

build: build-engine build-assets;

build-engine: engine_check ;
	@ ./setup.sh build

build-assets:
	@ gulp build

release:
	@ ./setup.sh release

deploy:
	@ ./setup.sh deploy

dev:
	@ NODE_ENV=development ./setup.sh "all"
# 	@ NODE_ENV=development gulp

##  ------------------------------------------------------------------------  ##

.PHONY: rebuild redeploy

rebuild: build release deploy;

redeploy: release deploy;

##  ------------------------------------------------------------------------  ##

.PHONY: all full
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

# all: clean rights tree setup engine build release deploy;
all: clean rights tree setup deps build release deploy;

full: clean-all all;

##  ------------------------------------------------------------------------  ##
