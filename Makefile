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

RC_FILE := src/.env.rc.local

ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
RC_FILE := $(subst local,${APP_ENV},${RC_FILE})
endif
$(info [${Cyan}${DT}${NC}] ${BYellow}RC_FILE${NC}: [${White}${RC_FILE}${NC}]);

ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
RC_FILE := src/.env.rc
endif

RC_FILE := $(addprefix ${WD}/,${RC_FILE})
$(info [${Cyan}${DT}${NC}] ${BYellow}RC_FILE${NC}: [${BPurple}${RC_FILE}${NC}]);

##  ------------------------------------------------------------------------  ##

COMMIT_EXISTS := $(shell [ -f COMMIT ] && echo 1 || echo 0)
ifeq ($(COMMIT_EXISTS),0)
$(file > COMMIT,${GIT_COMMIT})
$(info [${Cyan}${DT}${NC}] Created file [${BYellow}COMMIT${NC}:${BPurple}${GIT_COMMIT}${NC}])
endif

RC_EXISTS := $(shell [ -e ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS),0)
$(info [${Cyan}${DT}${NC}]${BYellow} Missing RESOURCE file: ${NC}[${BRed}${RC_FILE}${NC}])
exit 1
endif

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
# Query the default goal.

ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
endif
$(info [${Cyan}${DT}${NC}] ${BYellow}.DEFAULT_GOAL${NC} is SET TO: [${BPurple}$(.DEFAULT_GOAL)${NC}])

##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include ./bin/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: default

default: banner state help;
	@echo [${Cyan}${DT}${NC}] ${BYellow}FINISHED${NC} [${BBlue}DEFAULT${NC}] ${BYellow}GOAL${NC} ;

##  ------------------------------------------------------------------------  ##

.PHONY: test test_rc

test: test_rc;

## SOURCE VARIABLES
test_rc: $(RC_FILE);
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
	@ rm -rvf ${DIR_BUILD}/public/css ;
	@ rm -rvf ${DIR_BUILD}/public/js ;
	@ rm -rvf ${DIR_BUILD}/resources/assets/js ;
	@ rm -rvf ${DIR_BUILD}/*.md ;
	@ cp -prf ${DIR_SRC}/* ${DIR_BUILD}/ ;
	@ cp -pvu ${RC_FILE} ${DIR_BUILD}/.env ;
	@ cp -pvf ${DIR_SRC}/composer.json ${DIR_BUILD}/ ;
	@ cp -pvf ${DIR_SRC}/webpack.mix.js ${DIR_BUILD}/ ;
	@ cd ${DIR_BUILD} \
	&& npm i \
	&& composer --version > COMPOSER_VERSION \
	&& composer -v --no-interaction update ;

# @ mv -bfv ${DIR_BUILD}/.env ${DIR_BUILD}/.env.${DATE}.bak 2>&1 >/dev/null ;

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
	@ $(MAKE) -f $(THIS_FILE) ownership ;

# @ cp -pvf ${DIR_BUILD}/.env ${DIR_DIST}/ ;

deploy:
	@ mkdir -p ${DIR_WEB} 2>&1 >/dev/null ;
	@ [ -f ${DIR_WEB}/.env ] && cp -prf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null || echo "NO .env FILE";
	@ cp -prf ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null ;
	@ cp -pvu ${RC_FILE} ${DIR_WEB}/.env 2>&1 >/dev/null ;
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& composer -v --no-interaction update \
	&& php artisan --no-interaction up ;

# @ $(MAKE) -f $(THIS_FILE) artisan;

# dev: clean setup build release deploy;
dev: clean-dev build release deploy;

# @ NODE_ENV=development ./setup.sh "all"
# 	@ NODE_ENV=development gulp

##  ------------------------------------------------------------------------  ##

.PHONY: artisan ownership

artisan:
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& php artisan -V > ENGINE_VERSION 2>&1 >/dev/null \
	&& php artisan inspire > INSPIRATION 2>&1 >/dev/null \
	&& php artisan -n optimize 2>&1 >/dev/null \
	&& php artisan -n route:cache 2>&1 >/dev/null \
	&& php artisan -n config:cache 2>&1 >/dev/null \
	&& php artisan -n route:list \
	&& php artisan --no-interaction up ;

# && php artisan -n key:generate \
# && php artisan --no-interaction vendor:publish \

ownership:
	@ sudo chgrp -R ${WEB_USER} ${DIR_WEB} ;

# @ cd ${DIR_WEB} \
# && $(MAKE) rights ;
##  ------------------------------------------------------------------------  ##

.PHONY: rebuild redeploy

rebuild: build release deploy;

redeploy: release deploy;

##  ------------------------------------------------------------------------  ##

.PHONY: all full
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

# all: clean rights tree setup engine build release deploy;
all: clean rights setup deps build release deploy;

full: clean-all all;

##  ------------------------------------------------------------------------  ##
