##  ------------------------------------------------------------------------  ##
##                           Engine operations                                ##
##  ------------------------------------------------------------------------  ##
# $(info [$(lastword $(MAKEFILE_LIST))])
# include ./bin/.bash_colors

##  ------------------------------------------------------------------------  ##
$(shell [ -d "$(DIR_ENGINE)" ] || mkdir -p "$(DIR_ENGINE)");

ENGINE_EXISTS := $(shell [ -d ${DIR_ENGINE} ] && echo 1 || echo 0)
$(info $(DAT) $(Yellow)ENGINE_EXISTS$(NC): [$(BRed)$(ENGINE_EXISTS)$(NC)]);
ifeq ($(ENGINE_EXISTS), 0)
$(info $(DAT) $(Red)Missing DIR_ENGINE$(NC): [$(Gray)$(DIR_ENGINE)$(NC)]);
# exit 1
else
$(info $(DAT) Reuse $(Yellow)ENGINE DIR$(NC): [$(BCyan)$(DIR_ENGINE)$(NC)]);
endif

##  ------------------------------------------------------------------------  ##
.PHONY: engine_check engine_update engine_set_permissions
.PHONY: engine_setup engine_setup_git engine_setup_composer

engine_check: engine_setup engine_update engine_set_permissions ;
	@ echo $(DAT) ${Yellow}ENGINE CHECKED${NC}: [${Purple}${DIR_ENGINE}${NC}] ;
	@ echo $(DAT) $(FINE) $(TARG) ;

# $(info $(DAT) ${Red}ENGINE INSTALLED into ${NC}[${BYellow}${DIR_ENGINE}${NC}])

engine_setup_git: ;
	git clone -b "${ENGINE_VERSION}" "https://github.com/laravel/laravel" "${DIR_ENGINE}" $(TO_NULL);
	@ echo $(DAT) ${Yellow}Engine${NC} [${Blue}${ENGINE_NAME}-${ENGINE_TAG}${NC}] [${Orange}v${ENGINE_VERSION}${NC}] cloned to [${Purple}${DIR_ENGINE}${NC}] ;
	@ echo $(DAT) $(DONE) $(TARG) ;

engine_setup_composer: ;
	composer 							\
			-vvv 							\
			--no-interaction 	\
			--profile 				\
			--prefer-dist 		\
		create-project 			\
			${ENGINE_NAME}/${ENGINE_TAG} "${DIR_ENGINE}" "${ENGINE_VERSION}.*" \
	;
	@ echo $(DAT) $(DONE) $(TARG) ;

engine_setup: engine_setup_git ;
	mkdir -p "/data/media/audio" ;
	mkdir -p "${DIR_ENGINE}/storage/media" ;
	# [ -L "${DIR_ENGINE}/storage/media/audio" || -f "${DIR_ENGINE}/storage/media/audio" ] || ln -bs /data/media/audio "${WD}/${DIR_ENGINE}/storage/media/" ;
	cd ${WD} \
	&& [ -L "${DIR_ENGINE}/storage/media/audio" ] || ln -bs /data/media/audio "${DIR_ENGINE}/storage/media/" 2>&1 >/dev/null ;
	@ echo $(DAT) ${Yellow}ENGINE INSTALLED to${NC}: [${Purple}${DIR_ENGINE}${NC}] ;
	@ echo $(DAT) $(DONE) $(TARG) ;

# ln -s /data/media/audio ${DIR_ENGINE}/storage/media/audio ;
# @ mkdir -p ${DIR_ENGINE}/storage/media/audio/ ;

engine_update: ;
	cd "${DIR_ENGINE}" \
	&& npm i --verbose \
	&& composer -vvv self-update --2 \
	&& composer -vvv -n update ;
	@ echo $(DAT) ${Yellow}ENGINE UPDATED${NC}: [${Purple}${DIR_ENGINE}${NC}] ;
	@ echo $(DAT) $(DONE) $(TARG) ;

#&& composer -vv -n --profile update ;

engine_set_permissions: ;
	sudo chmod 775 ${DIR_ENGINE} \
		&& sudo chmod 775 ${DIR_ENGINE}/storage \
		&& sudo chmod 775 ${DIR_ENGINE}/storage/media \
		&& sudo chmod 775 ${DIR_ENGINE}/storage/media/audio \
		&& sudo chmod 775 ${DIR_ENGINE}/bootstrap/cache \
		&& sudo chmod a+x ${DIR_ENGINE}/artisan \
		&& sudo chgrp -R ${WEB_USER} ${DIR_ENGINE} \
	;
	@ echo $(DAT) $(DONE) $(TARG) ;

##  ------------------------------------------------------------------------  ##
