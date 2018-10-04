##  ------------------------------------------------------------------------  ##
##                           Engine operations                                ##
##  ------------------------------------------------------------------------  ##

# include ./bin/Colors.mk

##  ------------------------------------------------------------------------  ##

$(shell [ -d $(DIR_ENGINE) ] || mkdir -p $(DIR_ENGINE));

ENGINE_EXISTS := $(shell [ -e ${DIR_ENGINE} ] && echo 1 || echo 0)
ifeq ($(ENGINE_EXISTS), 0)
$(info [${Cyan}${DT}${NC}]${BRed} Missing DIR_ENGINE: ${NC}[${BPurple}${DIR_ENGINE}${NC}]);
# exit 1
else
$(info [${Cyan}${DT}${NC}]${BYellow} DIR_ENGINE EXIST: ${NC}[${BPurple}${DIR_ENGINE}${NC}]);
endif

##  ------------------------------------------------------------------------  ##

.PHONY: engine_check engine_setup engine_set_permissions

engine_check: engine_setup engine_set_permissions ;
	@ echo [${White}${DT}${NC}] ${BYellow}ENGINE INSTALLED into ${NC}[${BPurple}${DIR_ENGINE}${NC}] ;

# $(info [${Cyan}${DT}${NC}]${BRed} ENGINE INSTALLED into ${NC}[${BYellow}${DIR_ENGINE}${NC}])

engine_setup:
	@ git clone -b "${ENGINE_VERSION}" "https://github.com/laravel/laravel" ${DIR_ENGINE} ;
	@ mkdir -p ${DIR_ENGINE}/storage/media/audio/ ;
	@ echo [${Cyan}${DT}${NC}] ${BYellow}Engine [${BBlue}${ENGINE_NAME}-${ENGINE_TAG}${NC}] [${BGreen}v${ENGINE_VERSION}${NC}] cloned to [${BPurple}${DIR_ENGINE}${NC}] and UPDATED ;

# @ composer -vvv \
		# create-project \
		# --prefer-dist \
		# ${ENGINE_NAME}/${ENGINE_TAG} "${DIR_ENGINE}" "${ENGINE_VERSION}.*" ;
	# @ cd ${DIR_ENGINE} \
	# && npm i \
	# && composer -vvv --no-interaction update ;

# $(info [${Cyan}${DT}${NC}] ${BYellow}Engine [${BBlue}${ENGINE_NAME}-${ENGINE_TAG}${NC}] [${BGreen}v${ENGINE_VERSION}${NC}] cloned to [${BPurple}${DIR_ENGINE}${NC}])

engine_set_permissions:
	@  sudo chmod 775 ${DIR_ENGINE} \
	&& sudo chmod 775 ${DIR_ENGINE}/storage \
	&& sudo chmod 775 ${DIR_ENGINE}/storage/media \
	&& sudo chmod 775 ${DIR_ENGINE}/storage/media/audio \
	&& sudo chmod 775 ${DIR_ENGINE}/bootstrap/cache \
	&& sudo chmod a+x ${DIR_ENGINE}/artisan \
	&& sudo chgrp -R ${WEB_USER} ${DIR_ENGINE} ;

##  ------------------------------------------------------------------------  ##
