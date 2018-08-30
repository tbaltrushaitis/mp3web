##  ------------------------------------------------------------------------  ##
##                            Clean operations                                ##
##  ------------------------------------------------------------------------  ##

# include ./bin/Colors.mk

##  ------------------------------------------------------------------------  ##

.PHONY: clean clean-all clean-dev
.PHONY: clean-repo clean-src clean-deps
.PHONY: clean-build clean-dist clean-engine clean-web clean-files

clean-all: clean clean-deps clean-web clean-engine clean-files

clean-dev: clean clean-web clean-engine clean-files

clean: clean-build clean-dist

clean-repo:
	# @ rm -rf ${APP_NAME} 2>/dev/null
	-rm -rf ${APP_NAME}

clean-src:
	# @ rm -rf ${DIR_SRC}
	-rm -rf ${DIR_SRC}

clean-build:
	-rm -rf ${DIR_BUILD}

clean-dist:
	-rm -rf ${DIR_DIST}

clean-engine:
	# @ rm -rf engine/${DIR_ENGINE}
	-rm -rf engine/

clean-web:
	-rm -rf ${DIR_WEB}

clean-deps:
	@ rm -rf bower_modules/ \
		node_modules/;
	# @ git reset HEAD .gitmodules ${DIR_ENGINE}

clean-files:
	@ rm -rf ${APP_DIRS}  			\
		bitbucket-pipelines.yml		\
		codeclimate-config.patch	\
		_config.yml;
# package-lock.json

##  ------------------------------------------------------------------------  ##
