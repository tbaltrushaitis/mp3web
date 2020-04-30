##  ------------------------------------------------------------------------  ##
##                            Clean operations                                ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])

# include ./bin/Colors

##  ------------------------------------------------------------------------  ##

.PHONY: clean clean-all clean-dev
.PHONY: clean-repo clean-src clean-deps
.PHONY: clean-build clean-dist clean-engine clean-web clean-files

clean-all: clean clean-deps clean-web clean-engine clean-files

clean-dev: clean-dist clean-files

clean: clean-build clean-dist clean-files

clean-repo:
	-rm -rf ${APP_NAME}

clean-src:
	-rm -rf ${DIR_SRC}

clean-build:
	-rm -rf ${DIR_BUILD}

clean-dist:
	-rm -rf ${DIR_DIST}

clean-engine:
	-rm -rf ${DIR_ENGINE}

clean-web:
	-rm -rf ${DIR_WEB}

clean-deps:
	@ rm -rf bower_modules/ \
		node_modules/ ;
# @ git reset HEAD .gitmodules ${DIR_ENGINE}

clean-files:
	@ rm -rf bitbucket-pipelines.yml \
		codeclimate-config.patch \
		_config.yml \
		package-lock.json \
		COMMIT \
		*.md ;

	# @ rm -rf ${APP_DIRS} \

##  ------------------------------------------------------------------------  ##
