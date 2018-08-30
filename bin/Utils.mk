##  ------------------------------------------------------------------------  ##
##                      Report Environment Variables                          ##
##  ------------------------------------------------------------------------  ##

include ./bin/.bash_colors

##  ------------------------------------------------------------------------  ##

.PHONY: state

state:
	@ echo ${BCyan}---------------------------------------------------------${NC};
	@ echo ${BYellow}ENVIRONMENT VARS:${NC};
	@ echo ${BCyan}APPLICATION:${NC};
	@ echo "\t DT \t\t = ${DT}";
	@ echo "\t APP_NAME \t = ${APP_NAME}";
	@ echo "\t APP_ENV \t = ${APP_ENV}";
	@ echo "\t APP_DEBUG \t = ${APP_DEBUG}";
	@ echo "\t APP_DIRS \t = [${APP_DIRS}]";
	@ echo ${BCyan}REPOSITORY:${NC};
	@ echo "\t APP_BRANCH \t = ${APP_BRANCH}";
	@ echo "\t REPO_URL \t = ${REPO_URL}";
	@ echo "\t GIT_COMMIT \t = ${GIT_COMMIT}";
	@ echo ${BCyan}ENGINE:${NC};
	@ echo "\t WD \t\t = ${WD}";
	@ echo "\t DIR_SRC \t = ${DIR_SRC}";
	@ echo "\t DIR_ENGINE \t = ${DIR_ENGINE}";
	@ echo ${BCyan}TARGETS:${NC};
	@ echo "\t DIR_BUILD \t = ${DIR_BUILD}";
	@ echo "\t DIR_DIST \t = ${DIR_DIST}";
	@ echo "\t DIR_WEB \t = ${DIR_WEB}";
	@ echo ${BCyan}---------------------------------------------------------${NC};

##  ------------------------------------------------------------------------  ##

# @ echo "\t REPO_HOST \t = \t ${REPO_HOST}";
# @ echo "\t REPO_USER \t = \t ${REPO_USER}";
# @ echo "\t APP_REPO \t = \t ${APP_REPO}";
# @ echo "\t APP_SRC \t = \t ${APP_SRC}";
# @ echo "\t APP_BUILD \t = \t ${APP_BUILD}";
# @ echo "\t APP_DIST \t = \t ${APP_DIST}";

##  ------------------------------------------------------------------------  ##
##                 Lists all targets defined in this makefile                 ##
##  ------------------------------------------------------------------------  ##

.PHONY: list
list:
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##
##                          Show project's banner                             ##
##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
	@ if [ -f ${APP_LOGO} ]; then cat ${APP_LOGO}; fi

##  ------------------------------------------------------------------------  ##

.PHONY: rights

rights:
	@ sudo find . -type f -exec chmod 664 {} 2>/dev/null \;
	@ sudo find . -type d -exec chmod 775 {} 2>/dev/null \;
	@ sudo find . -type f -name "*.sh" -exec chmod a+x {} 2>/dev/null \;
	@ sudo find . -type f -name "artisan" -exec chmod a+x {} 2>/dev/null \;

##  ------------------------------------------------------------------------  ##
