##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
# .IGNORE:
.ONESHELL:

SHELL = /bin/sh
THIS_FILE = $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null

# $(info [THIS_FILE:$(THIS_FILE)])

##  ------------------------------------------------------------------------  ##
$(shell [ -f NODE_ENV ] || cp -prfu config/.NODE_ENV ./NODE_ENV);
$(shell [ -f .bowerrc ] || cp -prfu config/.bowerrc ./);
$(shell [ -f .npmrc ] || cp -prfu config/.npmrc ./);
##  ------------------------------------------------------------------------  ##

APP_NAME := mp3web
APP_PREF := mp3web_
APP_SLOG := MP3WEB
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

$(shell [ -f ./VERSION ] || echo "0.0.0" > VERSION)
$(shell [ -f ./.env ] || echo "NODE_ENV=production" >> .env)

CODE_VERSION := $(strip $(shell cat ./VERSION))
GIT_BRANCH := $(shell git rev-list --remove-empty --max-count=1 --reverse --branches)
GIT_COMMIT := $(shell git rev-list --remove-empty --max-count=1 --reverse --remotes --date-order)

# DT = $(shell date +'%Y-%m-%dT%H:%M:%S.%s %Z')
DT = $(shell date +'%T')
TS = $(shell date +'%s')
DZ = $(shell date +'%Y%m%dT%H%M%S%:z')

WD := $(shell pwd -P)
BD := $(WD)/bin

DATE = $(shell date +'%Y%m%d%H%M%S')






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

FMP := ffmpeg -hide_banner -y -loglevel "error" -stats

DAT = [$(Gray)$(DT)$(NC)]
BEGIN = $(Yellow)$(On_Blue)BEGIN TARGET$(NC)
DONE = $(Yellow)$(On_Blue)DONE TARGET$(NC)
FINE = $(Yellow)$(On_Green)COMPLETED GOAL$(NC)
TARG = [$(Orange) $@ $(NC)]
THIS = [$(Red) $(THIS_FILE) $(NC)]
OKAY = [$(White) OK $(NC)]

##  ------------------------------------------------------------------------  ##
##  BUILDs counter
##  ------------------------------------------------------------------------  ##
$(file > $(BUILD_FILE),$(BUILD_CNTR))
$(info $(DAT) Created file [$(Yellow)$(BUILD_FILE)$(NC):$(Red)$(BUILD_CNTR)$(NC)])

##  ------------------------------------------------------------------------  ##
##  BUILD information
##  ------------------------------------------------------------------------  ##
BUILD_SOURCE = config/build.tpl
BUILD_CONFIG = config/build.json

# BUILD_CONTENT = $(strip $(shell cat $(BUILD_SOURCE)))
BUILD_CONTENT  = $(shell cat $(BUILD_SOURCE))
BUILD_CONTENT := $(subst BUILD_CNTR,$(BUILD_CNTR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_FULL,$(BUILD_FULL),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_DATE,$(BUILD_DATE),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_TIME,$(BUILD_TIME),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_YEAR,$(BUILD_YEAR),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst BUILD_HASH,$(BUILD_HASH),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst GIT_COMMIT,$(GIT_COMMIT),$(BUILD_CONTENT))
BUILD_CONTENT := $(subst CODE_VERSION,$(CODE_VERSION),$(BUILD_CONTENT))

$(file > $(BUILD_CONFIG),$(BUILD_CONTENT))
$(info $(DAT) Created file [$(Yellow)BUILD_CONTENT$(NC):$(White)$(WD)/config/build.json$(NC)])

##  ------------------------------------------------------------------------  ##
##  COMMIT information
##  ------------------------------------------------------------------------  ##
$(file > COMMIT,$(GIT_COMMIT));
$(info $(DAT) Created file [$(BYellow)COMMIT$(NC):$(White)$(GIT_COMMIT)$(NC)]);

##  ------------------------------------------------------------------------  ##
##                               DIRECTORIES                                  ##
##  ------------------------------------------------------------------------  ##

ARC := arch
SRC := src
BLD := build-${CODE_VERSION}
DST := dist-${CODE_VERSION}
# WEB := web-${CODE_VERSION}-${BUILD_CNTR}
WEB := webroot

$(shell [ -d $(ARC) ] || mkdir $(ARC))

##  ------------------------------------------------------------------------  ##
##                                 PATHS                                      ##
##  ------------------------------------------------------------------------  ##

DIR_SRC := $(WD)/$(SRC)
DIR_BUILD := $(WD)/$(BLD)
DIR_DIST := $(WD)/$(DST)
DIR_WEB := $(WD)/$(WEB)

$(shell [ -d $(DIR_SRC) ]   || mkdir $(DIR_SRC))
$(shell [ -d $(DIR_BUILD) ] || mkdir $(DIR_BUILD))
$(shell [ -d $(DIR_DIST) ]  || mkdir $(DIR_DIST))
$(shell [ -d $(DIR_WEB) ]   || mkdir $(DIR_WEB))

##  ------------------------------------------------------------------------  ##

# APP_ENV := $(strip $(shell [ -f NODE_ENV ] && cat NODE_ENV || cat config/.NODE_ENV))
APP_ENV := $(strip $(shell grep NODE_ENV .env | cut -d "=" -f 2))
ifeq ($(APP_ENV),)
$(info $(DAT) $(Orange)APP_ENV$(NC) is $(Yellow)$(On_Red)NOT DETECTED$(NC)!)
endif

##  ------------------------------------------------------------------------  ##

RC_FILE = ${WD}/src/.env.rc
RC_EXISTS := $(shell [ -f ${RC_FILE} ] && echo 1 || echo 0)
ifeq ($(RC_EXISTS),0)
$(info $(DAT) $(Red)Missing$(NC) $(Yellow)RC_FILE$(NC): [$(Red)$(RC_FILE)$(NC)]);
# exit
else
include $(RC_FILE)
$(info $(DAT) USE $(Yellow)RC_FILE$(NC): [$(Purple)$(RC_FILE)$(NC)]);
endif

RC_ENV = ${WD}/config/.env.rc.${APP_ENV}
ifeq ($(shell [ -f $(RC_ENV) ] && echo 1 || echo 0),0)
$(info $(DAT) [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(White)$(RC_ENV)$(NC)]);
else
$(info $(DAT) USE $(Yellow)RC_ENV$(NC): [$(Purple)$(RC_ENV)$(NC)]);
include $(RC_ENV)
endif

RC_ENV = ${WD}/config/.env.rc.local
ifeq ($(shell [ -f ${RC_ENV} ] && echo 1 || echo 0),0)
$(info $(DAT) [$(Red)NOT EXIST$(NC)] [$(Yellow)RC_ENV$(NC):$(White)$(RC_ENV)$(NC)]);
else
include $(RC_ENV)
$(info $(DAT) USE $(Yellow)RC_ENV$(NC): [$(Purple)$(RC_ENV)$(NC)]);
endif



REPO_URL := $(REPO_HOST)/$(REPO_USER)/$(REPO_NAME).git
DIR_ENGINE := engine/$(ENGINE_NAME)-$(ENGINE_VERSION)

APP_DIRS := $(addprefix ${WD}/,build-* dist-* web-*)


##  ------------------------------------------------------------------------  ##
##  Query default goal
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

PHONY := default run

default: run ;
	@ echo $(DAT) $(FINE): $(TARG) ;

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

run: banner state help test;
	@ echo $(DAT) ${Yellow}EXECUTING${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC} ;
	@ echo $(DAT) ${Yellow}FINISHED${NC} [${Blue}$(.DEFAULT_GOAL)${NC}] ${Yellow}GOAL${NC} ;
	@ echo $(DAT) $(FINE): $(TARG)


##  ------------------------------------------------------------------------  ##

PHONY += test test_rc

test: test_rc;
	@ echo $(DAT) $(DONE): $(TARG)

## SOURCE VARIABLES
test_rc: ;
	@ echo $(DAT) ${Yellow}EXECUTING${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC} ;
	@ echo $(DAT) ${Yellow}FINISHED${NC} [${Blue}TEST${NC}] ${Yellow}GOAL${NC} ;
	@ echo $(DAT) $(DONE): $(TARG)

##  ------------------------------------------------------------------------  ##

PHONY += deps deps-install

deps-install:;
	npm i
	bower i --production
	@ echo $(DAT) $(DONE): $(TARG)

deps: deps-install;
	@ echo $(DAT) $(FINE): $(TARG)

##  ------------------------------------------------------------------------  ##

PHONY += ownership

ownership:
	mkdir -p ${DIR_WEB} ;
	sudo chgrp -R ${WEB_USER} ${DIR_WEB} ;
	@ echo $(DAT) $(DONE): $(TARG)

##  ------------------------------------------------------------------------  ##

PHONY += setup engine build build-engine build-assets release deploy

setup: deps;
	@ echo $(DAT) $(FINE): $(TARG)

engine: engine_check;
	@ echo $(DAT) $(FINE): $(TARG)

build: build-engine build-assets;
	@ echo $(DAT) $(FINE): $(TARG)

build-engine: engine_check ;
	mkdir -p ${DIR_BUILD} ;
	cp -prf ${DIR_ENGINE}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/public/css 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/public/js 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/resources/assets/js 2>&1 >/dev/null ;
	-rm -rvf ${DIR_BUILD}/*.md 2>&1 >/dev/null ;
	cp -prf ${DIR_SRC}/* ${DIR_BUILD}/ 2>&1 >/dev/null ;
	cp -pvu ${RC_FILE} ${DIR_BUILD}/.env 2>&1 >/dev/null ;
	cp -pvf ${DIR_SRC}/composer.json ${DIR_BUILD}/ 2>&1 >/dev/null ;
	cp -pvf ${DIR_SRC}/webpack.mix.js ${DIR_BUILD}/ 2>&1 >/dev/null ;
	cd "${DIR_BUILD}" \
	&& npm i \
	&& composer -vv -n --profile update \
	&& composer --version > __COMPOSER_VERSION \
	&& php artisan --ansi -V > __ENGINE_VERSION \
	&& php artisan --ansi inspire > __INSPIRATION \
	&& cd - ;
	@ echo $(DAT) $(FINE): $(TARG)

build-assets:
	gulp --env=${APP_ENV} build ;
	mkdir -p "${DIR_BUILD}/public/assets/font-awesome" ;
	mkdir -p "${DIR_ENGINE}/storage/media" ;
	cd "${DIR_BUILD}/public/assets/font-awesome" \
	&& [ -L ./fonts ] || ln -bs ../fonts 2>&1 >/dev/null ;
	cd "${DIR_BUILD}/public" \
	&& [ -L "${WD}/${DIR_ENGINE}/storage/media/audio" ] || ln -bs "/data/media/audio" "${WD}/${DIR_ENGINE}/storage/media/audio" 2>&1 >/dev/null ;
	@ echo $(DAT) $(FINE): $(TARG)

# && [ -L "${WD}/${DIR_ENGINE}/storage/media/audio" || -f "${WD}/${DIR_ENGINE}/storage/media/audio" ] || ln -bs "/data/media/audio" "${WD}/${DIR_ENGINE}/storage/media/" 2>&1 >/dev/null ;
# && ln -s ../fonts 2>&1 >/dev/null ;
# && ln -s ../storage/media/audio/ 2>&1 >/dev/null ;

release:
	mkdir -p ${DIR_DIST} ;
	cp -prf ${DIR_BUILD}/* ${DIR_DIST}/ ;
	cp -pvf ${RC_FILE} ${DIR_DIST}/ ;
	cd ${DIR_DIST} \
	&& rm -rf node_modules/ ;
	cd ${WD} ;
	@$(MAKE) ownership ;
	@ echo $(DAT) $(FINE): $(TARG)

deploy:
	mkdir -p ${DIR_WEB} 2>&1 >/dev/null ;
	[ -f "${DIR_WEB}/.env" ] && cp -prf ${DIR_WEB}/.env ${DIR_WEB}/.env.${DATE}.bak 2>&1 >/dev/null || echo "NO .env FILE";
	cp -prf ${DIR_DIST}/* ${DIR_WEB}/ 2>&1 >/dev/null ;
	cp -pv ${RC_FILE} ${DIR_WEB}/.env 2>&1 >/dev/null ;
	cd ${DIR_WEB} \
	&& php artisan --ansi down \
	&& composer -n -vv update \
	&& php artisan --ansi up ;
	# cd ${WD} && rm -vf webroot
	# cd ${WD} && ln -s ${DIR_WEB} webroot
	@ echo $(DAT) $(FINE): $(TARG)

##  ------------------------------------------------------------------------  ##

PHONY += artisan

artisan:
	@ cd ${DIR_WEB} \
	&& php artisan --ansi -n down \
	&& php artisan --ansi -n optimize 2>&1 >/dev/null \
	&& php artisan --ansi -n route:cache 2>&1 >/dev/null \
	&& php artisan --ansi -n config:cache 2>&1 >/dev/null \
	&& php artisan --ansi -n route:list \
	&& php artisan --ansi -n up ;
	@ echo $(DAT) $(FINE): $(TARG)

# @ cd ${DIR_WEB} \
# && $(MAKE) rights ;
##  ------------------------------------------------------------------------  ##

PHONY += rebuild redeploy

rebuild: build release deploy;
	@ echo $(DAT) $(FINE): $(TARG)

redeploy: release deploy;
	@ echo $(DAT) $(FINE): $(TARG)

##  ------------------------------------------------------------------------  ##

PHONY += all b dev full
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

b: build-assets release deploy;
	@ echo $(DAT) $(FINE): $(TARG)

dev: clean-dev setup build release deploy;
	@ echo $(DAT) $(FINE): $(TARG)

# all: clean rights tree setup engine build release deploy;
all: clean setup engine build release deploy;
	@ echo $(DAT) $(FINE): $(TARG)

full: clean-all all;
	@ echo $(DAT) $(FINE): $(TARG)

##  ------------------------------------------------------------------------  ##
##  Declare the contents of the .PHONY variable as phony. We keep that
##  information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)

##  ------------------------------------------------------------------------  ##
