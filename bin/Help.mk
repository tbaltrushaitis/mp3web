##  ------------------------------------------------------------------------  ##
##                              Show help topic                               ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])

##  ------------------------------------------------------------------------  ##

.PHONY: help

help: banner
	@ echo ${Cyan}----------------------------------------------------------${NC};
	@ echo ${Blue}Available commands:${NC};
	@ echo ${Yellow}make ${NC};
	@ echo "  " ${Green}list${NC} "\t" - LIST all targets defined in this makefile;
	@ echo "  " ${Green}clean${NC} "\t" - CLEAR directories and delete files;
	@ echo "  " ${Green}setup${NC} "\t" - check for php, node and bower installations;
	@ echo "  " ${Green}engine${NC} "\t" - setup and build engine;
	@ echo "  " ${Green}build${NC} "\t" - BUILD project from sources;
	@ echo "  " ${Green}release${NC} "\t" - COMPILE project distro;
	@ echo "  " ${Green}deploy${NC} "\t" - DEPLOY compiled project to \"webroot\" directory;
	@ echo "  " ${Purple}all${NC} "\t\t" - Run ${White}ALL${NC} operations for current stage from ${Blue}NODE_ENV${NC} file;
	@ echo "  " ${Purple}rebuild${NC} "\t" - Execute [${BGreen}build, release, deploy${NC}] tasks;
	@ echo "  " ${Purple}redeploy${NC} "\t" - Execute [${BGreen}release, deploy${NC}] tasks;
	@ echo ${Cyan}----------------------------------------------------------${NC};
	@ echo $(DAT) $(DONE): $(TARG) ;

##  ------------------------------------------------------------------------  ##
##                      Report Environment Variables                          ##
##  ------------------------------------------------------------------------  ##

.PHONY: state

state:
	@ echo $(Cyan)----------------------------------------------------------$(NC);
	@ echo $(Cyan)ENVIRONMENT VARS:$(NC);
	@ echo "\t"${Blue}APP_ENV${NC}"\t"= [${Red}$(APP_ENV)${NC}];
	@ echo "\t"${Blue}RC_FILE${NC}"\t"= [${Purple}$(RC_FILE)${NC}];
	@ echo "\t"${Blue}CODE_VERSION${NC}"\t"= [${Purple}$(CODE_VERSION)${NC}];
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
	@ echo "\t" REPO_HOST "\t" = [$(White)$(REPO_HOST)$(NC)];
	@ echo "\t" REPO_URL "\t" = [$(White)$(REPO_URL)$(NC)];
	@ echo "\t" REPO_BRANCH "\t" = [$(White)$(REPO_BRANCH)$(NC)];
	@ echo "\t" GIT_COMMIT "\t" = [$(White)$(GIT_COMMIT)$(NC)];
	@ echo ${Cyan}----------------------------------------------------------${NC};
	@ echo $(DAT) $(DONE): $(TARG) ;

##  ------------------------------------------------------------------------  ##
