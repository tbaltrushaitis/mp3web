##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##
$(shell set -x)

# Since we rely on paths relative to the makefile location,
# abort if make isn't being run from there.
$(if $(findstring /,$(MAKEFILE_LIST)),$(error Please only invoke this makefile from the directory it resides in))
THIS_FILE := $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null
# $(info [THIS_FILE:${THIS_FILE}])

##  ------------------------------------------------------------------------  ##
##  Suppress display of executed commands
##  ------------------------------------------------------------------------  ##
$(VERBOSE).SILENT:

##  ------------------------------------------------------------------------  ##
.EXPORT_ALL_VARIABLES:
# .IGNORE:

##  ------------------------------------------------------------------------  ##
# Use one shell to run all commands in a given target rather than using
# the default setting of running each command in a separate shell
##  ------------------------------------------------------------------------  ##
.ONESHELL:

##  ------------------------------------------------------------------------  ##
# set -e = bash immediately exits if any command has a non-zero exit status.
# set -u = a reference to any shell variable you haven't previously
#    defined -- with the exceptions of $* and $@ -- is an error, and causes
#    the program to immediately exit with non-zero code.
# set -o pipefail = the first non-zero exit code emitted in one part of a
#    pipeline (e.g. `cat file.txt | grep 'foo'`) will be used as the exit
#    code for the entire pipeline. If all exit codes of a pipeline are zero,
#    the pipeline will emit an exit code of 0.
# .SHELLFLAGS := -eu -o pipefail -c

##  ------------------------------------------------------------------------  ##
# Emits a warning if you are referring to Make variables that don’t exist.
##  ------------------------------------------------------------------------  ##
MAKEFLAGS += --warn-undefined-variables

##  ------------------------------------------------------------------------  ##
# Removes a large number of built-in rules. Remove "magic" and only do
#    what we tell Make to do.
##  ------------------------------------------------------------------------  ##
MAKEFLAGS += --no-builtin-rules

##  ========================================================================  ##
$(shell [ -f NODE_ENV ] || cp -prfu config/.NODE_ENV ./NODE_ENV);
$(shell [ -f ./.bowerrc ] || cp -prfu config/.bowerrc ./)
$(shell [ -f ./.npmrc ] || cp -prfu config/.npmrc ./)
$(shell [ -f ./.env ] || echo "NODE_ENV=production" >> .env)
$(shell [ -f ./VERSION ] || echo "0.0.0" > VERSION)

##  ========================================================================  ##
##  Environment variables for the build
##  ========================================================================  ##
include .env

# The shell in which to execute make rules
SHELL := /bin/sh

# The CMake executable
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file
# RM = /usr/bin/cmake -E remove -f

# Escaping for special characters
EQUALS = =

##  ========================================================================  ##
APP_NAME := mp3web
APP_PREF := mp3web_
APP_SLOG := MP3WEB
APP_LOGO := ./assets/BANNER

APP_REPO := $(shell git ls-remote --get-url)
# GIT_BRANCH := $(shell git rev-list --remove-empty --max-count=1 --reverse --branches)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT := $(shell git rev-list --remove-empty --max-count=1 --reverse --remotes --date-order)
CODE_VERSION := $(strip $(shell cat ./VERSION))

##  ------------------------------------------------------------------------  ##
DATE = $(shell date +'%Y%m%d%H%M%S')

# DT = $(shell date +'%Y-%m-%dT%H:%M:%S.%s %Z')
DT = $(shell date +'%T')
TS = $(shell date +'%s')
DZ = $(shell date +'%Y%m%dT%H%M%S%:z')

WD := $(shell pwd -P)
BD := $(WD)/bin


##  ------------------------------------------------------------------------  ##
##  BUILD SOURCE and TARGET files
##  ------------------------------------------------------------------------  ##
# BUILD_SOURCE = config/build.tpl
# BUILD_CONFIG = config/build.json
BUILD_TMPL := config/build.tpl
BUILD_DATA := config/build.json

BUILD_FILE = BUILD-$(CODE_VERSION)
BUILD_CNTR = $(strip $(shell [ -f "$(BUILD_FILE)" ] && cat $(BUILD_FILE) || echo 0))
BUILD_CNTR := $(shell echo $$(( $(BUILD_CNTR) + 1 )))

BUILD_FULL := $(shell date +'%Y-%m-%dT%H:%M:%S%:z')
BUILD_DATE := $(shell date +'%Y-%m-%d')
BUILD_TIME := $(shell date +'%H:%M:%S')
BUILD_YEAR := $(shell date +'%Y')
BUILD_HASH := $(shell echo "$(BUILD_FULL)" | md5sum | cut -b -4)

##  ------------------------------------------------------------------------  ##
##  Colors definition
##  ------------------------------------------------------------------------  ##
include $(BD)/Colors

##  ------------------------------------------------------------------------  ##
##  Shorthands
##  ------------------------------------------------------------------------  ##
LN := ln -sf --backup=simple
CP := cp -prf --backup=simple
MV := mv -f

FMP := ffmpeg -hide_banner -stats -loglevel error -y
FIGLET := figlet-toilet -t -k -f standard -F border -F gay
TOILET := figlet-toilet -t -f small -F border
GULP := gulp --color

ARGS = $(shell echo '$@' | tr [:upper:] [:lower:])
STG  = $(shell echo '$@' | tr [:lower:] [:upper:])

DAT = [$(Gray)$(DT)$(NC)]
BEGIN = $(Yellow)$(On_Blue)BEGIN RECIPE$(NC)
RESULT = $(White)$(On_Purple)RESULT$(NC)
DONE = $(Yellow)$(On_Blue)DONE RECIPE$(NC)
FINE = $(Yellow)$(On_Green)FINISHED GOAL$(NC)
TARG = [$(Orange) $@ $(NC)]
THIS = [$(Red) $(THIS_FILE) $(NC)]
OKAY = [$(White) OK $(NC)]
FAIL = [$(Red)$(On_Yellow) FAILED $(NC)]

##  ------------------------------------------------------------------------  ##
##                               ENVIRONMENT                                  ##
##  ------------------------------------------------------------------------  ##
NODE_ENV := $(shell grep NODE_ENV ./.env | cut -d "=" -f 2)
APP_ENV := $(NODE_ENV)
DEBUG := $(shell grep DEBUG ./.env | cut -d "=" -f 2)
APP_DEBUG := $(DEBUG)
ifeq ($(APP_ENV),)
$(info $(DAT) $(Orange)APP_ENV$(NC) is $(Yellow)$(On_Red)NOT DETECTED$(NC)!)
endif


##  ------------------------------------------------------------------------  ##
##  BUILDs counter
##  ------------------------------------------------------------------------  ##
$(file > $(BUILD_FILE),$(BUILD_CNTR))
$(info $(DAT) Write build counter in [$(Yellow)$(BUILD_FILE)$(NC):$(Red)$(BUILD_CNTR)$(NC)])

##  ------------------------------------------------------------------------  ##
##  BUILD information
##  ------------------------------------------------------------------------  ##
# BUILD_CONTENT = $(strip $(shell cat $(BUILD_SOURCE)))
BUILD_CONTENT  = $(strip $(shell cat $(BUILD_TMPL)))
BUILD_CONTENT := $(subst BUILD_CNTR,$(BUILD_CNTR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_FULL,$(BUILD_FULL),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_DATE,$(BUILD_DATE),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_TIME,$(BUILD_TIME),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_YEAR,$(BUILD_YEAR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_HASH,$(BUILD_HASH),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst APP_ENV,$(APP_ENV),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst GIT_BRANCH,$(GIT_BRANCH),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst GIT_COMMIT,$(GIT_COMMIT),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst CODE_VERSION,$(CODE_VERSION),$(BUILD_CONTENT))

# $(file > $(BUILD_CONFIG),$(BUILD_CONTENT))
# $(info $(DAT) Created file [$(Yellow)BUILD_CONFIG$(NC):$(White)$(WD)/$(BUILD_CONFIG)$(NC)])
$(file > $(BUILD_DATA),$(BUILD_CONTENT))
$(info $(DAT) Created file [$(Yellow)BUILD_DATA$(NC):$(Cyan)$(WD)/$(BUILD_DATA)$(NC)])

##  ------------------------------------------------------------------------  ##
##  COMMIT information
##  ------------------------------------------------------------------------  ##
$(file > COMMIT,$(GIT_COMMIT));
$(info $(DAT) Created file [$(Yellow)COMMIT$(NC):$(Gray)$(GIT_COMMIT)$(NC)]);


##  ------------------------------------------------------------------------  ##
##                               DIRECTORIES                                  ##
##  ------------------------------------------------------------------------  ##
ARC := arch
SRC := src
VER := v$(CODE_VERSION)-b$(BUILD_CNTR)
# BLD := build-${CODE_VERSION}
# DST := dist-${CODE_VERSION}
# WEB := web-${CODE_VERSION}-${BUILD_CNTR}
# WEB := webroot
BLD := build-$(CODE_VERSION)-$(BUILD_CNTR)
DST := dist-$(CODE_VERSION)-$(BUILD_CNTR)
WEB := web-$(CODE_VERSION)-$(BUILD_CNTR)
DEV := dev-$(CODE_VERSION)-$(BUILD_CNTR)

APP_UID := $(shell echo "$(APP_NAME)" | tr [:lower:] [:upper:])-$(VER)-$(APP_ENV)


##  ------------------------------------------------------------------------  ##
##                                 PATHS                                      ##
##  ------------------------------------------------------------------------  ##
DIR_ARC := $(WD)/$(ARC)
DIR_SRC := $(WD)/$(SRC)
# DIR_BUILD := $(WD)/$(BLD)
# DIR_DIST := $(WD)/$(DST)
# DIR_WEB := $(WD)/$(WEB)
DIR_BUILD := $(WD)/$(BLD)-$(APP_ENV)
DIR_DIST := $(WD)/$(DST)-$(APP_ENV)
DIR_WEB := $(WD)/$(WEB)-$(APP_ENV)

APP_DIRS := $(addprefix ${WD}/,build-* dist-* web-*)

$(shell [ -d $(DIR_ARC) ]   || mkdir $(DIR_ARC))
$(shell [ -d $(DIR_SRC) ]   || mkdir $(DIR_SRC))
$(shell [ -d $(DIR_BUILD) ] || mkdir $(DIR_BUILD))
$(shell [ -d $(DIR_DIST) ]  || mkdir $(DIR_DIST))
$(shell [ -d $(DIR_WEB) ]   || mkdir $(DIR_WEB))


##  ------------------------------------------------------------------------  ##
##                   INCLUDES ENVIRONMENT CONFIGURATION                       ##
##  ------------------------------------------------------------------------  ##
RC_FILE = ${WD}/src/.env.rc
RC_EXISTS := $(shell [ -f ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS),0)
$(info $(DAT) $(Red)Missing$(NC) [$(Yellow)RC_FILE$(NC):$(Red)$(RC_FILE)$(NC)]);
# exit
else
$(info $(DAT) [$(Yellow)$(On_Green)USE$(NC)] [$(Yellow)RC_FILE$(NC):$(Purple)$(RC_FILE)$(NC)]);
include $(RC_FILE)
endif

RC_ENV = ${WD}/config/.env.rc.${APP_ENV}
ifeq ($(shell [ -f $(RC_ENV) ] && echo 1 || echo 0),0)
$(info $(DAT) [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(Gray)$(RC_ENV)$(NC)]);
else
$(info $(DAT) [$(Yellow)$(On_Green)USE$(NC)] [$(Yellow)RC_ENV$(NC):$(Purple)$(RC_ENV)$(NC)]);
include $(RC_ENV)
endif

RC_ENV = ${WD}/config/.env.rc.local
ifeq ($(shell [ -f ${RC_ENV} ] && echo 1 || echo 0),0)
$(info $(DAT) [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(Gray)$(RC_ENV)$(NC)]);
else
$(info $(DAT) [$(Yellow)$(On_Green)USE$(NC)] [$(Yellow)RC_ENV$(NC):$(Purple)$(RC_ENV)$(NC)]);
include $(RC_ENV)
endif


REPO_URL := $(REPO_HOST)/$(REPO_USER)/$(REPO_NAME).git
DIR_ENGINE := engine/$(ENGINE_NAME)-$(ENGINE_VERSION)


##  ------------------------------------------------------------------------  ##
##  Query the default goal
##  ------------------------------------------------------------------------  ##
ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
endif
$(info $(DAT) $(Yellow)$(On_Purple)GOALS$(NC));
$(info $(DAT)   \-- $(Orange)DEFAULT$(NC): [$(White)$(.DEFAULT_GOAL)$(NC)]);
$(info $(DAT)   \-- $(Orange)CURRENT$(NC): [$(Blue)$(MAKECMDGOALS)$(NC)]);


##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##
include $(BD)/*.mk

##  ------------------------------------------------------------------------  ##
##                             SET DEFAULT GOAL                               ##
##  ------------------------------------------------------------------------  ##
PHONY := default

default: run ;
	@ echo $(DAT) $(FINE) $(TARG)

##  ------------------------------------------------------------------------  ##
# APP_BANNER := $(shell cat ${APP_LOGO})

##  ------------------------------------------------------------------------  ##
##  ENVIRONMENT CONFIG
##  ------------------------------------------------------------------------  ##
# include ./bin/Configure.mk

##  ------------------------------------------------------------------------  ##
##                   INCLUDES ENVIRONMENT CONFIGURATION                       ##
##  ------------------------------------------------------------------------  ##
# ifeq ($(shell [ -f ${RC_FILE} ] && echo 1 || echo 0),0)
# include $(RC_FILE)
# $(info $(DAT) USE ${BYellow}RC_FILE${NC}: [${BPurple}${RC_FILE}${NC}]);
# else
# $(info $(DAT) [${Red}NOT EXIST${NC}] [${BYellow}RC_FILE${NC}:${White}${RC_FILE}${NC}]);
# endif

##  ------------------------------------------------------------------------  ##
PHONY += run

run: banner state help test ;
	@ echo $(DAT) ${Yellow}EXECUTING${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC}
	@ echo $(DAT) ${Yellow}FINISHED${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC}
	@ echo $(DAT) $(FINE) $(TARG)


##  ------------------------------------------------------------------------  ##
PHONY += test test_rc

test: test_rc ;
	@ echo $(DAT) ${Yellow}EXECUTING${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC}
	# @ export NODE_ENV="${APP_ENV}"; npm run test
	@ echo $(DAT) ${Yellow}FINISHED${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC}
	@ echo $(DAT) $(FINE) $(TARG)

## SOURCE VARIABLES
test_rc: ;
	@ echo $(DAT) ${Yellow}EXECUTING${NC} [${Blue}TEST_RC${NC}] ${Yellow}GOAL${NC}
	@ echo $(DAT) ${Yellow}FINISHED${NC} [${Blue}TEST_RC${NC}] ${Yellow}GOAL${NC}
	@ echo $(DAT) $(FINE) $(TARG)

##  ------------------------------------------------------------------------  ##
PHONY += deps deps-install

deps-install: ;
	npm i
	bower i --production
	@ echo $(DAT) $(DONE): $(TARG)

deps: deps-install ;
	@ echo $(DAT) $(FINE): $(TARG)

##  ------------------------------------------------------------------------  ##
PHONY += ownership

ownership: ;
	mkdir -p ${DIR_WEB}
	sudo chgrp -R ${WEB_USER} ${DIR_WEB}
	@ echo $(DAT) $(DONE) $(TARG)

##  ------------------------------------------------------------------------  ##
PHONY += setup engine build build-engine build-assets engine_check release deploy

setup: deps ;
	@ echo $(DAT) $(FINE): $(TARG)

engine: engine_check ;
	@ echo $(DAT) $(FINE): $(TARG)

build: build-engine build-assets ;
	@ echo $(DAT) $(FINE): $(TARG)

build-engine: engine_check ;
	mkdir -p ${DIR_BUILD} ;
	cp -prf ${DIR_ENGINE}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/public/css 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/public/js 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/resources/assets/js 2>&1 >/dev/null ;
	# -rm -rvf ${DIR_BUILD}/*.md 2>&1 >/dev/null ;
	cp -prvf ${DIR_SRC}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	cp -pvf ${RC_FILE} ${DIR_BUILD}/.env 2>&1 >/dev/null ;
	# cp -pvf ${DIR_SRC}/composer.json ${DIR_BUILD}/ 2>&1 >/dev/null ;
	# cp -pvf ${DIR_SRC}/webpack.mix.js ${DIR_BUILD}/ 2>&1 >/dev/null ;
	# && composer install \
	cd "${DIR_BUILD}" \
	&& npm i \
	&& composer update \
		--ansi \
		-n \
		-vv \
		--no-dev \
	&& composer --version > .COMPOSER_VERSION \
	&& php artisan inspire > .INSPIRATION_ \
	&& cd - ;
	@ echo $(DAT) $(DONE): $(TARG)

build-assets: ;
	gulp --env=${APP_ENV} build ;
	mkdir -p "${DIR_BUILD}/public/assets/font-awesome" ;
	mkdir -p "${DIR_ENGINE}/storage/media" ;
	cd "${DIR_BUILD}/public/assets/font-awesome" \
	&& [ -L ./fonts ] || ln -bs ../fonts 2>&1 >/dev/null ;
	cd ${WD} \
	&& [ -L "${DIR_ENGINE}/storage/media/audio" ] || ln -bs "/data/media/audio" "${DIR_ENGINE}/storage/media/" 2>&1 >/dev/null ;
	cd "${DIR_BUILD}/public" \
	&& [ -L "./audio" ] || ln -bs ../storage/media/audio 2>&1 >/dev/null ;
	cd ${WD}
	@ echo $(DAT) $(DONE): $(TARG)

# && [ -L "${WD}/${DIR_ENGINE}/storage/media/audio" || -f "${WD}/${DIR_ENGINE}/storage/media/audio" ] || ln -bs "/data/media/audio" "${WD}/${DIR_ENGINE}/storage/media/" 2>&1 >/dev/null ;
# && ln -s ../fonts 2>&1 >/dev/null ;

release: ;
	mkdir -p ${DIR_DIST}
	cp -prf ${DIR_BUILD}/* ${DIR_DIST}/
	cp -pvf ${RC_FILE} ${DIR_DIST}/
	cd ${DIR_DIST} \
	&& rm -rf node_modules/ ;
	@ echo $(DAT) $(FINE): $(TARG)

# cd ${WD} \
# && $(MAKE) ownership ;

pre-deploy: ;
	$(RM) -vf ./deploy
	@ echo $(DAT) $(DONE) $(TARG)

deploy: dist ownership pre-deploy ;
	mkdir -p ${DIR_WEB}
	[ -f "${DIR_WEB}/.env" ] && cp -prf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null || echo "NO .env FILE"
	cd ${WD} && cp -prf ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null
	# cp -pv ${RC_FILE} ${DIR_WEB}/.env 2>&1 >/dev/null ;
	cd ${DIR_WEB} 								\
		&& php artisan --ansi down 	\
		&& composer update 					\
			-n 												\
			-vvv 											\
			--no-dev 									\
		&& php artisan --ansi up 		\
	;
	# --no-autoloader \
	# cd ${WD} && rm -vf webroot
	# cd ${WD} && ln -s ${DIR_WEB} webroot
	cd ${WD}
	$(RM) -vf devroot 2>&1 >/dev/null
	$(RM) -vf webroot 2>&1 >/dev/null
	$(LN) ${DIR_DIST} devroot
	$(LN) ${DIR_WEB} webroot
	touch ./$(ARGS)
	@ echo $(DAT) $(DONE) $(TARG): [$(Cyan)$(DIR_WEB)$(NC)]
	@ echo $(HR)
	# @ echo $(DAT) $(FINE) $(TARG)

##  ------------------------------------------------------------------------  ##
PHONY += artisan

artisan: ;
	@ cd ${DIR_WEB} \
	&& php artisan --ansi -n down --message="Upgrade is in progress ... " \
	&& php artisan --ansi -n optimize 2>&1 \
	&& php artisan --ansi -n route:cache 2>&1 \
	&& php artisan --ansi -n config:cache 2>&1 \
	&& php artisan --ansi -n route:list \
	&& php artisan --ansi -n up ;
	@ echo $(DAT) $(DONE) $(TARG)

# @ cd ${DIR_WEB} \
# && $(MAKE) rights ;

##  ------------------------------------------------------------------------  ##
PHONY += rebuild redeploy

rebuild: build release deploy ;
	@ echo $(DAT) $(FINE) $(TARG)

redeploy: release deploy ;
	@ echo $(DAT) $(FINE) $(TARG)

##  ------------------------------------------------------------------------  ##
PHONY += all b dev full
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

# all: clean rights tree setup engine build release deploy;
all: clean setup engine build release deploy ;
	@ echo $(DAT) $(FINE) $(TARG)

b: build-assets release deploy ;
	@ echo $(DAT) $(FINE) $(TARG)

dev: clean-dev setup build release deploy ;
	@ echo $(DAT) $(FINE) $(TARG)

full: clean-all all ;
	@ echo $(DAT) $(FINE) $(TARG)

##  ------------------------------------------------------------------------  ##
##  Declare the contents of the .PHONY variable as phony. We keep that
##  information in a variable so we can use it in if_changed and friends.
##  ------------------------------------------------------------------------  ##
.PHONY: $(PHONY)

##  ------------------------------------------------------------------------  ##
