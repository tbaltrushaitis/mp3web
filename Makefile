##  ------------------------------------------------------------------------  ##
##                                Build Project                               ##
##  ------------------------------------------------------------------------  ##

REPO_HOST := "https://bitbucket.org"
REPO_NAME := "tbaltrushaitis"
APP_NAME := "mp3web"

# APP_REPO := "https://github.com/tbaltrushaitis/mp3web.git"
APP_REPO := "${REPO_HOST}/${REPO_NAME}/${APP_NAME}.git"
APP_ENV := "$(shell cat .NODE_ENV)"
APP_BRANCH := "dev-1.0.2"

WD := "$(shell pwd -P)"
APP_DIRS := $(addprefix ${WD}/,src build dist)
APP_SRC := "${WD}/src"
APP_BUILD := "${WD}/build"
APP_DIST := "${WD}/dist"

DT = $(shell date +'%Y%m%d%H%M%S')

# MEDIUM := "$(shell ./setup.sh)"

##  ------------------------------------------------------------------------  ##
default: state help

help:
	@echo "AVAILABLE COMMANDS:";
	@echo "\t make clean \t - CLEAR directories and delete files";
	@echo "\t make clone \t - CLONE project sources from provided repo";
	@echo "\t make dev \t - prepare DEV environment";
	@echo "\t make setup";
	@echo "\t make build";

state:
	@echo "ENVIRONMENT VARS:";
	@echo "\t DT \t = \t ${DT}";
	@echo "\t WD \t = \t ${WD}";
	@echo "\t REPO_HOST \t = \t ${REPO_HOST}";
	@echo "\t REPO_NAME \t = \t ${REPO_NAME}";
	@echo "\t APP_NAME \t = \t ${APP_NAME}";
	@echo "\t APP_REPO \t = \t ${APP_REPO}";
	@echo "\t APP_BRANCH \t = \t ${APP_BRANCH}";
	@echo "\t APP_ENV \t = \t ${APP_ENV}";
	@echo "\t APP_SRC \t = \t ${APP_SRC}";
	@echo "\t APP_BUILD \t = \t ${APP_BUILD}";
	@echo "\t APP_DIST \t = \t ${APP_DIST}";
	@echo "\t APP_DIRS \t = \t ${APP_DIRS}";

##  ------------------------------------------------------------------------  ##

# .SILENT:

.EXPORT_ALL_VARIABLES:

# .IGNORE:

##  ------------------------------------------------------------------------  ##

clone:
	@  git clone -b ${APP_BRANCH} ${APP_REPO} 	\
	&& cd ${APP_NAME} 													\
	&& git pull																	\
	&& git branch											  				\
	&& find . -type f -exec chmod 664 {} \; 		\
	&& find . -type d -exec chmod 775 {} \; 		\
	&& find . -type f -name "*.sh" -exec chmod 755 {} \;

##  ------------------------------------------------------------------------  ##

clean: clean-build clean-dist

clean-repo:
	@ rm -rf "${APP_NAME}"

clean-src:
	@ rm -rf "${APP_SRC}"

clean-build:
	@ rm -rf "${APP_BUILD}"

clean-dist:
	@ rm -rf "${APP_DIST}"

##  ------------------------------------------------------------------------  ##

tree:
	@ ./setup.sh tree

##  ------------------------------------------------------------------------  ##

compile:
	@ ./setup.sh "build"

release:
	@ ./setup.sh "release"

deploy:
	@ ./setup.sh "deploy"

# dev:
# 	@ NODE_ENV=development ./setup.sh "all"
# 	# @ NODE_ENV=development gulp

##  ------------------------------------------------------------------------  ##

##  ------------------------------------------------------------------------  ##

	all: help clean clone compile release install setup update tree dev prod

	#* means the word "all" doesn't represent a file name in this Makefile;
	#* means the Makefile has nothing to do with a file called "all" in the same directory.

	.PHONY: all

##  ------------------------------------------------------------------------  ##
