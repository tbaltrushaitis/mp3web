THIS_FILE = $(lastword $(MAKEFILE_LIST))
# $(info [THIS_FILE:$(THIS_FILE)])

##  ------------------------------------------------------------------------  ##
H1 = ${Yellow}${On_Blue}
H2 = " - "${Blue}
H3 = "\\t"
HR = ${Cyan}"----------------------------------------------------------"${NC}


##  ------------------------------------------------------------------------  ##
##                              Show help topic                               ##
##  ------------------------------------------------------------------------  ##
.PHONY: help

help: banner
	@ echo $(HR) ;
	# @ echo ${Cyan}----------------------------------------------------------${NC};
	@ echo ${BBlue}Available commands:${NC};
	@ echo ${Yellow}make ${NC};
	@ echo "  " ${Green}list${NC} "\t" - LIST all targets defined in this makefile;
	@ echo "  " ${Green}clean${NC} "\t" - CLEAR directories and delete files;
	@ echo "  " ${Green}setup${NC} "\t" - check for php, node and bower installations;
	@ echo "  " ${Green}engine${NC} "\t" - setup and build engine;
	@ echo "  " ${Green}build${NC} "\t" - BUILD project from sources;
	@ echo "  " ${Green}release${NC} "\t" - COMPILE project distro;
	@ echo "  " ${Green}deploy${NC} "\t" - DEPLOY compiled project to \"webroot\" directory;
	@ echo "  " ${Purple}all${NC} "\t\t" - Run ${White}ALL${NC} operations for current stage [$(Red)$(APP_ENV)$(NC)] which was read from ${Blue}NODE_ENV${NC} file;
	@ echo "  " ${Purple}rebuild${NC} "\t" - Execute [${White}build, release, deploy${NC}] tasks;
	@ echo "  " ${Purple}redeploy${NC} "\t" - Execute [${White}release, deploy${NC}] tasks;
	@ echo $(HR) ;
	@ echo $(DAT) $(FINE) $(TARG) ;

##  ------------------------------------------------------------------------  ##
##                      Report Environment Variables                          ##
##  ------------------------------------------------------------------------  ##

.PHONY: state

state:
	@ echo $(HR) ;
	# @ echo $(Cyan)----------------------------------------------------------$(NC);
	@ echo $(Cyan)ENVIRONMENT VARS:$(NC) ;
	@ echo "\t"${Blue}NODE_ENV${NC}"\t" = [${Red}$(NODE_ENV)${NC}] ;
	@ echo "\t"${Blue}RC_FILE${NC}"\t\t" = [${Purple}$(RC_FILE)${NC}] ;
	@ echo "\t"${Blue}CODE_VERSION${NC}"\t" = [${Yellow}$(CODE_VERSION)${NC}] ;
	@ echo "\t"${Blue}BUILD_CNTR${NC}"\t" = [${Red}$(BUILD_CNTR)${NC}] ;
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
	@ echo $(HR) ;
	@ echo $(DAT) $(FINE) $(TARG) ;

##  ------------------------------------------------------------------------  ##
