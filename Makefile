##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

SHELL = /bin/sh
THIS_FILE := $(lastword $(MAKEFILE_LIST))

##  ------------------------------------------------------------------------  ##

APP_SLOG := MP3WEB
APP_LOGO := ./assets/BANNER

APP_ENV := $(shell cat ./NODE_ENV)
APP_BANNER := $(shell cat ${APP_LOGO})

CODE_VERSION := $(shell cat ./VERSION)
GIT_COMMIT := $(shell git rev-list --remove-empty --remotes --max-count=1 --date-order --reverse)

WD := $(shell pwd -P)
DT = $(shell date +'%Y-%m-%dT%H:%M:%S %Z')
DATE = $(shell date +'%Y%m%d%H%M%S')

include ./bin/Colors.mk

##  ------------------------------------------------------------------------  ##

RC_FILE = ${WD}/src/.env.rc.${APP_ENV}

ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
$(info [${Yellow}${DT}${NC}] ${BYellow}RC_FILE${NC} [${White}${RC_FILE}${NC}] ${Red}NOT EXIST${NC});
RC_FILE = ${WD}/src/.env.rc.local
endif
$(info [${Cyan}${DT}${NC}] Get ${BYellow}RC_FILE${NC} as [${White}${RC_FILE}${NC}]);

ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
$(info [${Yellow}${DT}${NC}] ${BYellow}RC_FILE${NC} [${White}${RC_FILE}${NC}] ${Red}NOT EXIST${NC});
RC_FILE = ${WD}/src/.env.rc
endif
$(info [${Cyan}${DT}${NC}] Set ${BYellow}RC_FILE${NC} to [${BPurple}${RC_FILE}${NC}]);

##  ------------------------------------------------------------------------  ##

COMMIT_EXISTS := $(shell [ -f COMMIT ] && echo 1 || echo 0)
ifeq ($(COMMIT_EXISTS),0)
$(file > COMMIT,${GIT_COMMIT})
$(info [${Cyan}${DT}${NC}] Created file [${BYellow}COMMIT${NC}:${BPurple}${GIT_COMMIT}${NC}])
endif

RC_EXISTS := $(shell [ -f ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS),0)
$(info [${Cyan}${DT}${NC}]${BYellow} Missing RESOURCE file: ${NC}[${BRed}${RC_FILE}${NC}]);
# exit 0
endif

##  ------------------------------------------------------------------------  ##
# Query the default goal.

ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
endif
$(info [${Cyan}${DT}${NC}] ${BYellow}.DEFAULT_GOAL${NC} is SET TO: [${BPurple}$(.DEFAULT_GOAL)${NC}])

##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include $(RC_FILE)

##  ------------------------------------------------------------------------  ##

REPO_URL := ${REPO_HOST}/${REPO_USER}/${REPO_NAME}.git
DIR_ENGINE := engine/${ENGINE_NAME}-${ENGINE_VERSION}

DIR_SRC := ${WD}/src
DIR_BUILD := ${WD}/build-${CODE_VERSION}
DIR_DIST := ${WD}/dist-${CODE_VERSION}
DIR_WEB := ${WD}/webroot

APP_DIRS := $(addprefix ${WD}/,build-* dist-* webroot)

##  ------------------------------------------------------------------------  ##

include ./bin/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: default

default: banner state help test;
	@echo [${Cyan}${DT}${NC}] ${BYellow}FINISHED${NC} [${BBlue}$(.DEFAULT_GOAL)${NC}] ${BYellow}GOAL${NC} ;


##  ------------------------------------------------------------------------  ##

.PHONY: test test_rc

test: test_rc;

## SOURCE VARIABLES
test_rc: ;
	@echo [${Cyan}${DT}${NC}] ${BYellow}EXECUTING${NC} [${BBlue}TEST${NC}] ${BYellow}GOAL${NC} ;

##  ------------------------------------------------------------------------  ##

.PHONY: deps deps-install

deps-install:
	@ bower i --production
	@ npm i

deps: deps-install;

##  ------------------------------------------------------------------------  ##

.PHONY: setup engine build build-engine build-assets release deploy

setup: deps;

engine: engine_check;

build: build-engine build-assets;

build-engine: engine_check ;
	@ mkdir -p ${DIR_BUILD} 2>&1 >/dev/null ;
	@ cp -prf ${DIR_ENGINE}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	@ rm -rvf ${DIR_BUILD}/public/css 2>&1 >/dev/null ;
	@ rm -rvf ${DIR_BUILD}/public/js 2>&1 >/dev/null ;
	@ rm -rvf ${DIR_BUILD}/resources/assets/js 2>&1 >/dev/null ;
	@ rm -rvf ${DIR_BUILD}/*.md 2>&1 >/dev/null ;
	@ cp -prf ${DIR_SRC}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	@ cp -pvu ${RC_FILE} ${DIR_BUILD}/.env 2>&1 >/dev/null ;
	@ cp -pvf ${DIR_SRC}/composer.json ${DIR_BUILD}/ 2>&1 >/dev/null ;
	@ cp -pvf ${DIR_SRC}/webpack.mix.js ${DIR_BUILD}/ 2>&1 >/dev/null ;
	@ cd ${DIR_BUILD} \
	&& npm i \
	&& composer -v -n --profile update \
	&& composer --version > COMPOSER_VERSION 2>&1 >/dev/null \
	&& php artisan -V > ENGINE_VERSION 2>&1 >/dev/null \
	&& php artisan inspire > INSPIRATION 2>&1 >/dev/null ;

build-assets:
	@ gulp --env=${APP_ENV} build ;
	@ mkdir -p ${DIR_BUILD}/public/assets/font-awesome ;
	@ cd ${DIR_BUILD}/public/assets/font-awesome \
	&& ln -s ../fonts ;
	@ cd ${DIR_BUILD}/public \
	&& ln -s ../storage/media/audio/ ;

release:
	@ mkdir -p ${DIR_DIST} ;
	@ cp -prf ${DIR_BUILD}/* ${DIR_DIST}/ ;
	@ cp -pvf ${RC_FILE} ${DIR_DIST}/ ;
	@ cd ${DIR_DIST} \
	&& rm -rf node_modules/ ;
	@$(MAKE) ownership ;

deploy:
	@ mkdir -p ${DIR_WEB} 2>&1 >/dev/null ;
	@ [ -f ${DIR_WEB}/.env ] && cp -prf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null || echo "NO .env FILE";
	@ cp -prf ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null ;
	@ cp -pvu ${RC_FILE} ${DIR_WEB}/.env 2>&1 >/dev/null ;
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& composer -v -n --profile update \
	&& php artisan --no-interaction up ;

##  ------------------------------------------------------------------------  ##

.PHONY: artisan ownership

artisan:
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& php artisan -n optimize 2>&1 >/dev/null \
	&& php artisan -n route:cache 2>&1 >/dev/null \
	&& php artisan -n config:cache 2>&1 >/dev/null \
	&& php artisan -n route:list \
	&& php artisan --no-interaction up ;

ownership:
	@ sudo chgrp -R ${WEB_USER} ${DIR_WEB} ;

# @ cd ${DIR_WEB} \
# && $(MAKE) rights ;
##  ------------------------------------------------------------------------  ##

.PHONY: rebuild redeploy

rebuild: build release deploy;

redeploy: release deploy;

##  ------------------------------------------------------------------------  ##

.PHONY: all b dev full
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

b: build-assets release deploy;

dev: clean-dev setup build release deploy;

# all: clean rights tree setup engine build release deploy;
all: clean setup build release deploy;

full: clean-all all;

##  ------------------------------------------------------------------------  ##
