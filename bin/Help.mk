##  ------------------------------------------------------------------------  ##
##                              Show help topic                               ##
##  ------------------------------------------------------------------------  ##

# include ./bin/.bash_colors

##  ------------------------------------------------------------------------  ##

.PHONY: help

help: banner
	@ echo ${BCyan}---------------------------------------------------------${NC};
	@ echo ${BBlue}Available commands:${NC};
	@ echo ${Yellow}make ${NC};
	@ echo "  " ${BGreen}list${NC} "\t" - LIST all targets defined in this makefile;
	@ echo "  " ${BGreen}clean${NC} "\t" - CLEAR directories and delete files;
	@ echo "  " ${BGreen}setup${NC} "\t" - check for php, node and bower installations;
	@ echo "  " ${BGreen}engine${NC} "\t" - setup and build engine;
	@ echo "  " ${BGreen}build${NC} "\t" - BUILD project from sources;
	@ echo "  " ${BGreen}release${NC} "\t" - COMPILE project distro;
	@ echo "  " ${BGreen}deploy${NC} "\t" - DEPLOY compiled project to \"webroot\" directory;
	@ echo "  " ${BPurple}all${NC} "\t" -${BGreen}Run all operations for current stage from NODE_ENV file${NC};
	@ echo "  " ${BPurple}rebuild${NC} "\t" -${BGreen}Execute [build, release, deploy] tasks${NC};
	@ echo "  " ${BPurple}redeploy${NC} "\t" -${BGreen}Execute [release, deploy] tasks${NC};
	@ echo ${BCyan}---------------------------------------------------------${NC};

##  ------------------------------------------------------------------------  ##
##                      Report Environment Variables                          ##
##  ------------------------------------------------------------------------  ##

.PHONY: state

state:
	@ echo $(BCyan)---------------------------------------------------------$(NC);
	@ echo $(BCyan)ENVIRONMENT VARS:$(NC);
	@ echo "\t"${BBlue}APP_ENV${NC}"\t"= [${BRed}$(APP_ENV)${NC}];
	@ echo "\t"${BBlue}RC_FILE${NC}"\t"= [${BPurple}$(RC_FILE)${NC}];
	@ echo "\t"${BBlue}CODE_VERSION${NC}"\t"= [${BPurple}$(CODE_VERSION)${NC}];
	@ echo ${Yellow}APPLICATION:${NC};
	@ echo "\t DT \t\t = [$(DT)]";
	@ echo "\t APP_NAME \t = [$(APP_NAME)]";
	@ echo "\t APP_HOME \t = [${APP_HOME}]";
	@ echo "\t APP_BASE \t = [${APP_BASE}]";
	@ echo "\t APP_ENV \t = [${APP_ENV}]";
	@ echo "\t APP_KEY \t = [${APP_KEY}]";
	@ echo "\t APP_DEBUG \t = [${APP_DEBUG}]";
	@ echo "\t APP_LOG_LEVEL \t = [${APP_LOG_LEVEL}]";
	@ echo "\t APP_URL \t = [${APP_URL}]";
	@ echo ${Yellow}MAKE TARGETS:${NC};
	@ echo "\t APP_DIRS \t = [${APP_DIRS}]";
	@ echo "\t DIR_BUILD \t = [${DIR_BUILD}]";
	@ echo "\t DIR_DIST \t = [${DIR_DIST}]";
	@ echo "\t DIR_WEB \t = [${DIR_WEB}]";
	@ echo ${Yellow}ENGINE:${NC};
	@ echo "\t WD \t\t = [${WD}]";
	@ echo "\t DIR_SRC \t = [${DIR_SRC}]";
	@ echo "\t DIR_ENGINE \t = [${DIR_ENGINE}]";
	@ echo ${Yellow}REPOSITORY:${NC};
	@ echo "\t REPO_URL \t = [${REPO_URL}]";
	@ echo "\t REPO_BRANCH \t = [${REPO_BRANCH}]";
	@ echo "\t" GIT_COMMIT "\t" = [$(White)$(GIT_COMMIT)$(NC)];
	@ echo ${BCyan}---------------------------------------------------------${NC};

##  ------------------------------------------------------------------------  ##
