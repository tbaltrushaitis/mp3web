##  ------------------------------------------------------------------------  ##
##                        Create application BANNER                           ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])

.ONESHELL:

# include ./bin/.bash_colors


.PHONY: logo

logo:
	@ echo "${Cyan}--------------------------------------------------------${NC}";
	figlet-toilet 	\
		--termwidth 		\
		--font standard \
		--filter border \
		--filter gay 		\
		$(shell echo '"' ${APP_SLOG} '"' | tr [:lower:] [:upper:]) \
		--export "utf8" \
		> ${APP_LOGO} 	\
	;
	figlet-toilet 	\
		--termwidth 		\
		--font standard \
		--filter border \
		$(shell echo '"' ${APP_SLOG} '"' | tr [:lower:] [:upper:]) \
		--export "utf8" \
		> "${APP_LOGO}.txt" \
	;
	figlet-toilet 	\
		--termwidth 		\
		--font standard \
		--filter border \
		--filter gay 		\
		$(shell echo '"' ${APP_SLOG} '"' | tr [:lower:] [:upper:]) \
		--export "html" \
		> "${APP_LOGO}.html" \
	;
	figlet-toilet 	\
		--termwidth 		\
		--font big 			\
		--filter border \
		--filter gay 		\
		$(shell echo '"' ${APP_SLOG} '"' | tr [:lower:] [:upper:]) \
		--export "svg" 	\
		> "${APP_LOGO}.svg" \
	;
	if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi ;
	@ echo "${Yellow}BANNER [${Purple}${APP_LOGO}${Yellow}] created${NC}";
	@ echo "${Cyan}--------------------------------------------------------${NC}";
	@ echo $(DAT) $(DONE): $(TARG) ;

##  ------------------------------------------------------------------------  ##
