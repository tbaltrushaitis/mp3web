##  ------------------------------------------------------------------------  ##
##                            Clean operations                                ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])

##  ------------------------------------------------------------------------  ##

.PHONY: clean clean-all clean-dev
.PHONY: clean-repo clean-src clean-deps
.PHONY: clean-build clean-dist clean-engine clean-web clean-files

clean-all: clean clean-deps clean-web clean-engine clean-files

clean-dev: clean-dist clean-files

clean: clean-build clean-dist clean-files

clean-repo:
	-rm -rf ${APP_NAME}
	@ echo $(DAT) $(FINE): $(TARG) ;

clean-src:
	-rm -rf ${DIR_SRC}
	@ echo $(DAT) $(FINE): $(TARG) ;

clean-build:
	-rm -rf ${DIR_BUILD}
	@ echo ${DAT} ${FINE}: ${TARG} ;

clean-dist:
	-rm -rf ${DIR_DIST}
	@ echo ${DAT} ${FINE}: ${TARG} ;

clean-engine:
	-rm -rf ${DIR_ENGINE}
	@ echo ${DAT} ${FINE}: ${TARG} ;

clean-web:
	-rm -rf ${DIR_WEB}
	@ echo ${DAT} ${FINE}: ${TARG} ;

clean-deps:
	-rm -rf \
		bower_modules/ \
		node_modules/  \
	;
	@ echo ${DAT} ${FINE}: ${TARG} ;
# @ git reset HEAD .gitmodules ${DIR_ENGINE}

clean-files:
	-rm -rf \
		bitbucket-pipelines.yml \
		codeclimate-config.patch \
		_config.yml \
		package-lock.json \
		COMMIT \
		*.md \
	;
	@ echo ${DAT} ${FINE}: ${TARG} ;

	# @ rm -rf ${APP_DIRS} \

##  ------------------------------------------------------------------------  ##
