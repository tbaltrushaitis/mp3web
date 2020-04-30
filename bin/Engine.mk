##  ------------------------------------------------------------------------  ##
##                           Engine operations                                ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])
# include ./bin/Colors

##  ------------------------------------------------------------------------  ##

$(shell [ -d $(DIR_ENGINE) ] || mkdir -p $(DIR_ENGINE));

ENGINE_EXISTS := $(shell [ -e ${DIR_ENGINE} ] && echo 1 || echo 0)
ifeq ($(ENGINE_EXISTS), 0)
$(info [$(Gray)$(DT)$(NC)] $(Red)Missing DIR_ENGINE$(NC): [$(Purple)$(DIR_ENGINE)$(NC)]);
# exit 1
else
# $(info [${White}${DT}${NC}] Reuse ${Yellow}ENGINE DIR${NC}: [${Purple}${DIR_ENGINE}${NC}]);
$(info [$(Gray)$(DT)$(NC)] Reuse $(Yellow)ENGINE DIR$(NC): [$(Purple)$(DIR_ENGINE)$(NC)]);
endif

##  ------------------------------------------------------------------------  ##

.PHONY: engine_check engine_update engine_set_permissions
.PHONY: engine_setup engine_setup_git engine_setup_composer

engine_check: engine_setup engine_update engine_set_permissions ;
	@ echo [${Gray}${DT}${NC}] ${Yellow}ENGINE CHECKED${NC}: [${Purple}${DIR_ENGINE}${NC}] ;

# $(info [${Cyan}${DT}${NC}]${BRed} ENGINE INSTALLED into ${NC}[${BYellow}${DIR_ENGINE}${NC}])

engine_setup_git:
	@ git clone -b "${ENGINE_VERSION}" "https://github.com/laravel/laravel" "${DIR_ENGINE}" $(TO_NULL);
	@ echo [${Gray}${DT}${NC}] ${Yellow}Engine [${Blue}${ENGINE_NAME}-${ENGINE_TAG}${NC}] [${Green}v${ENGINE_VERSION}${NC}] cloned to [${Purple}${DIR_ENGINE}${NC}] ;

engine_setup_composer:
	@ composer \
			-vv \
			--no-interaction \
			--profile \
			--prefer-dist \
		create-project \
			${ENGINE_NAME}/${ENGINE_TAG} "${DIR_ENGINE}" "${ENGINE_VERSION}.*" ;

engine_setup: engine_setup_git ;
	@ mkdir -p ${DIR_ENGINE}/storage/media/audio/ ;
	@ echo [${Gray}${DT}${NC}] ${Yellow}ENGINE INSTALLED to${NC}: [${Purple}${DIR_ENGINE}${NC}] ;

engine_update: ;
	@ cd ${DIR_ENGINE} \
	&& npm i \
	&& composer -vv -n --profile update ;
	@ echo [${Gray}${DT}${NC}] ${Yellow}ENGINE UPDATED${NC}: [${Purple}${DIR_ENGINE}${NC}] ;

engine_set_permissions:
	@  sudo chmod 775 ${DIR_ENGINE} \
	&& sudo chmod 775 ${DIR_ENGINE}/storage \
	&& sudo chmod 775 ${DIR_ENGINE}/storage/media \
	&& sudo chmod 775 ${DIR_ENGINE}/storage/media/audio \
	&& sudo chmod 775 ${DIR_ENGINE}/bootstrap/cache \
	&& sudo chmod a+x ${DIR_ENGINE}/artisan \
	&& sudo chgrp -R ${WEB_USER} ${DIR_ENGINE} ;

##  ------------------------------------------------------------------------  ##
