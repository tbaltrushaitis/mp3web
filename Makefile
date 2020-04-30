##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

# .SILENT:
.EXPORT_ALL_VARIABLES:
# .IGNORE:
.ONESHELL:

SHELL = /bin/sh
THIS_FILE = $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null

$(info [THIS_FILE:$(THIS_FILE)])

##  ------------------------------------------------------------------------  ##
$(shell [ -f NODE_ENV ] || cp -prfu config/.NODE_ENV ./NODE_ENV);
$(shell [ -f .bowerrc ] || cp -prfu config/.bowerrc ./);
$(shell [ -f .npmrc ] || cp -prfu config/.npmrc ./);
##  ------------------------------------------------------------------------  ##

APP_NAME := mp3web
APP_SLOG := MP3WEB
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

CODE_VERSION := $(shell cat ./VERSION)
GIT_COMMIT := $(shell git rev-list --remove-empty --remotes --max-count=1 --date-order --reverse)
WD := $(shell pwd -P)
DT = $(shell date +'%Y-%m-%dT%H:%M:%S.%s %Z')
DATE = $(shell date +'%Y%m%d%H%M%S')

# APP_ENV := $(shell cat ./NODE_ENV)
APP_ENV := $(strip $(shell [ -f NODE_ENV ] && cat NODE_ENV || cat config/.NODE_ENV))
ifeq ($(APP_ENV),)
$(info [$(Gray)$(DT)$(NC)] APP_ENV is NOT DETECTED!)
endif

# APP_BANNER := $(shell cat ${APP_LOGO})

BUILD_FILE = BUILD-$(CODE_VERSION)
BUILD_CNTR = $(strip $(shell [ -f "$(BUILD_FILE)" ] && cat $(BUILD_FILE) || echo 0))
BUILD_CNTR := $(shell echo $$(( $(BUILD_CNTR) + 1 )))

BUILD_FULL := $(shell date +'%Y-%m-%dT%H:%M:%SZ %Z')
BUILD_DATE := $(shell date +'%Y-%m-%d')
BUILD_TIME := $(shell date +'%H:%M:%S')
BUILD_YEAR := $(shell date +'%Y')
BUILD_HASH := $(shell echo "$(BUILD_FULL)" | md5sum | cut -b -4)

##  ------------------------------------------------------------------------  ##
##  Colors definitions
##  ------------------------------------------------------------------------  ##

include ./bin/Colors

##  ------------------------------------------------------------------------  ##
##  ENVIRONMENT CONFIG
##  ------------------------------------------------------------------------  ##

# include ./bin/Configure.mk

##  ------------------------------------------------------------------------  ##
##  COMMIT information
##  ------------------------------------------------------------------------  ##
$(file > COMMIT,$(GIT_COMMIT));
$(info [$(Gray)$(DT)$(NC)] Created file [$(Yellow)COMMIT$(NC):$(Purple)$(GIT_COMMIT)$(NC)]);

##  ------------------------------------------------------------------------  ##
##  BUILDs counter
##  ------------------------------------------------------------------------  ##
$(file > $(BUILD_FILE),$(BUILD_CNTR))
$(info [$(Gray)$(DT)$(NC)] Created file [$(Yellow)$(BUILD_FILE)$(NC):$(Purple)$(BUILD_CNTR)$(NC)])

# ##  ------------------------------------------------------------------------  ##
# ##  BUILD information
# ##  ------------------------------------------------------------------------  ##
BUILD_SOURCE=config/build.tpl
BUILD_CONFIG=config/build.json
# BUILD_CONTENT = $(strip $(shell cat config/build.tpl))
BUILD_CONTENT = $(shell cat $(BUILD_SOURCE))
BUILD_CONTENT := $(subst BUILD_CNTR,$(BUILD_CNTR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_FULL,$(BUILD_FULL),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_DATE,$(BUILD_DATE),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_TIME,$(BUILD_TIME),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_YEAR,$(BUILD_YEAR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_HASH,$(BUILD_HASH),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst GIT_COMMIT,$(GIT_COMMIT),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst CODE_VERSION,$(CODE_VERSION),$(BUILD_CONTENT))

# # $(info [$(White)$(DT)$(NC)] BUILD_CONTENT [$(Yellow)$(BUILD_CONTENT)$(NC)])
# $(file > config/build.json,$(BUILD_CONTENT))
$(file > $(BUILD_CONFIG),$(BUILD_CONTENT))
$(info [$(Gray)$(DT)$(NC)] Created file [$(Yellow)BUILD_CONTENT$(NC):$(Purple)$(WD)/$(BUILD_CONFIG)$(NC)])

##  ------------------------------------------------------------------------  ##

RC_FILE = ${WD}/src/.env.rc
RC_EXISTS := $(shell [ -f ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS),0)
$(info [$(Gray)$(DT)$(NC)] $(Red)Missing$(NC) $(Yellow)RC_FILE$(NC): [$(Red)$(RC_FILE)$(NC)]) ;
# exit
else
include $(RC_FILE)
$(info [$(Gray)$(DT)$(NC)] USE $(Yellow)RC_FILE$(NC): [$(Purple)$(RC_FILE)$(NC)]) ;
endif

RC_ENV = ${WD}/src/.env.rc.${APP_ENV}
ifeq ($(shell [ -f ${RC_ENV} ] && echo 1 || echo 0),0)
$(info [$(Gray)$(DT)$(NC)] [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(White)$(RC_ENV)$(NC)]);
else
$(info [$(Gray)$(DT)$(NC)] USE $(Yellow)RC_ENV$(NC): [$(Purple)$(RC_ENV)$(NC)]);
include $(RC_ENV)
endif

RC_ENV = ${WD}/src/.env.rc.local
ifeq ($(shell [ -f ${RC_ENV} ] && echo 1 || echo 0),0)
$(info [$(Gray)$(DT)$(NC)] [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(White)$(RC_ENV)$(NC)]);
else
include $(RC_ENV)
$(info [$(Gray)$(DT)$(NC)] USE $(Yellow)RC_ENV$(NC): [$(Purple)$(RC_ENV)$(NC)]);
endif

##  ------------------------------------------------------------------------  ##
##                   INCLUDES ENVIRONMENT CONFIGURATION                       ##
##  ------------------------------------------------------------------------  ##

# ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
# include $(RC_FILE)
# $(info [${White}${DT}${NC}] USE ${BYellow}RC_FILE${NC}: [${BPurple}${RC_FILE}${NC}]);
# else
# $(info [${White}${DT}${NC}] [${Red}NOT EXIST${NC}] [${BYellow}RC_FILE${NC}:${White}${RC_FILE}${NC}]);
# endif

##  ------------------------------------------------------------------------  ##

# COMMIT_EXISTS := $(shell [ -f COMMIT ] && echo 1 || echo 0)
# ifeq ($(COMMIT_EXISTS),0)
# $(file > COMMIT,${GIT_COMMIT})
# $(info [${Cyan}${DT}${NC}] Created file [${BYellow}COMMIT${NC}:${BPurple}${GIT_COMMIT}${NC}])
# endif

##  ------------------------------------------------------------------------  ##
##  Query default goal.
##  ------------------------------------------------------------------------  ##
ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
endif
$(info [$(Gray)$(DT)$(NC)] $(Yellow)Goal$(NC) [$(Yellow)DEFAULT$(NC):$(Purple)$(.DEFAULT_GOAL)$(NC)]);
$(info [$(Gray)$(DT)$(NC)] $(Yellow)Goal$(NC) [$(Yellow)CURRENT$(NC):$(Purple)$(MAKECMDGOALS)$(NC)]);

##  ------------------------------------------------------------------------  ##
##                               DIRECTORIES                                  ##
##  ------------------------------------------------------------------------  ##

REPO_URL := ${REPO_HOST}/${REPO_USER}/${REPO_NAME}.git
DIR_ENGINE := engine/${ENGINE_NAME}-${ENGINE_VERSION}

DIR_SRC := ${WD}/src
DIR_BUILD := ${WD}/build-${CODE_VERSION}
DIR_DIST := ${WD}/dist-${CODE_VERSION}
DIR_WEB := ${WD}/webroot

APP_DIRS := $(addprefix ${WD}/,build-* dist-* webroot)

##  ------------------------------------------------------------------------  ##
##                          INCLUDES Makefiles                                ##
##  ------------------------------------------------------------------------  ##

include ./bin/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: default

default: banner state help test;
	@echo [${Gray}${DT}${NC}] ${Yellow}EXECUTING${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC} ;
	@echo [${Gray}${DT}${NC}] ${Yellow}FINISHED${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC} ;


##  ------------------------------------------------------------------------  ##

.PHONY: test test_rc

test: test_rc;

## SOURCE VARIABLES
test_rc: ;
	@echo [${Cyan}${DT}${NC}] ${Yellow}EXECUTING${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC} ;
	@echo [${Cyan}${DT}${NC}] ${Yellow}FINISHED${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC} ;

##  ------------------------------------------------------------------------  ##

.PHONY: deps deps-install

deps-install:
	@ bower i --production
	@ npm i

deps: deps-install;

##  ------------------------------------------------------------------------  ##

.PHONY: ownership

ownership:
	@ mkdir -p ${DIR_WEB} ;
	@ sudo chgrp -R ${WEB_USER} ${DIR_WEB} ;

##  ------------------------------------------------------------------------  ##

.PHONY: setup engine build build-engine build-assets release deploy

setup: deps;

engine: engine_check;

build: build-engine build-assets;

build-engine: engine_check ;
	@ mkdir -p ${DIR_BUILD} ;
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
	&& composer -vv -n --profile update \
	&& composer --version > __COMPOSER_VERSION \
	&& php artisan -V > __ENGINE_VERSION \
	&& php artisan inspire > __INSPIRATION \
	&& cd - ;

build-assets:
	@ gulp --env=${APP_ENV} build ;
	@ mkdir -p ${DIR_BUILD}/public/assets/font-awesome ;
	@ mkdir -p ${DIR_ENGINE}/storage/media ;
	@ cd ${DIR_BUILD}/public/assets/font-awesome \
	&& [ -L ./fonts || -e ./fonts ] || ln -s ../fonts ;
	@ cd ${DIR_BUILD}/public \
	&& [ -L ${WD}/${DIR_ENGINE}/storage/media/audio || -e ${WD}/${DIR_ENGINE}/storage/media/audio ] || ln -s /data/media/audio ${WD}/${DIR_ENGINE}/storage/media/audio ;

# && ln -s ../fonts 2>&1 >/dev/null ;
# && ln -s ../storage/media/audio/ 2>&1 >/dev/null ;

release:
	@ mkdir -p ${DIR_DIST} ;
	@ cp -prf ${DIR_BUILD}/* ${DIR_DIST}/ ;
	@ cp -pvf ${RC_FILE} ${DIR_DIST}/ ;
	@ cd ${DIR_DIST} \
	&& rm -rf node_modules/ ;
	@ cd ${WD} ;
	@$(MAKE) ownership ;

deploy:
	@ mkdir -p ${DIR_WEB} 2>&1 >/dev/null ;
	@ [ -f ${DIR_WEB}/.env ] && cp -prf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null || echo "NO .env FILE";
	@ cp -prf ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null ;
	@ cp -pvu ${RC_FILE} ${DIR_WEB}/.env 2>&1 >/dev/null ;
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& composer -vv -n update \
	&& php artisan --no-interaction up ;

##  ------------------------------------------------------------------------  ##

.PHONY: artisan

artisan:
	@ cd ${DIR_WEB} \
	&& php artisan --no-interaction down \
	&& php artisan -n optimize 2>&1 >/dev/null \
	&& php artisan -n route:cache 2>&1 >/dev/null \
	&& php artisan -n config:cache 2>&1 >/dev/null \
	&& php artisan -n route:list \
	&& php artisan --no-interaction up ;

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
