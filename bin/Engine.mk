##  ------------------------------------------------------------------------  ##
##                           Engine operations                                ##
##  ------------------------------------------------------------------------  ##

include ./bin/Colors.mk

##  ------------------------------------------------------------------------  ##

ENGINE_EXISTS := $(shell [ -e ${DIR_ENGINE} ] && echo 1 || echo 0)
ifeq ($(ENGINE_EXISTS), 0)
$(warning [${Cyan}${DT}${NC}]${BRed} Missing DIR_ENGINE = [${BYellow}${DIR_ENGINE}${NC}]);
# exit 1
endif

##  ------------------------------------------------------------------------  ##

.PHONY: engine_check engine_setup engine_set_permissions

engine_check: engine_setup engine_set_permissions;

engine_setup:
	# @ composer -vvv \
		# create-project \
		# --prefer-dist ${ENGINE_NAME}/${ENGINE_TAG} "${DIR_ENGINE}" "${ENGINE_VERSION}.*"
	git clone -b "${ENGINE_VERSION}" "https://github.com/laravel/laravel" ${DIR_ENGINE}
	# $(info [${Cyan}${DT}${NC}] ${BYellow}Engine [${BBlue}${ENGINE_NAME}-${ENGINE_TAG}${NC}] [${BGreen}v${ENGINE_VERSION}${NC}] cloned to [${BPurple}${DIR_ENGINE}${NC}])

engine_set_permissions:
	@  sudo chmod 775 ${DIR_ENGINE} \
  && sudo chmod 775 ${DIR_ENGINE}/storage \
	&& sudo chmod 775 ${DIR_ENGINE}/bootstrap/cache \
  && sudo chmod a+x ${DIR_ENGINE}/artisan ;

# sudo chown -R ${WEB_USER}:${WEB_USER} ${DIR_ENGINE}

##  ------------------------------------------------------------------------  ##
