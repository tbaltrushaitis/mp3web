##  ------------------------------------------------------------------------  ##
##                             Utils and Helpers                              ##
##  ------------------------------------------------------------------------  ##

$(info [$(lastword $(MAKEFILE_LIST))])

include ./bin/.bash_colors

##  ------------------------------------------------------------------------  ##
##                 Lists all targets defined in this makefile                 ##
##  ------------------------------------------------------------------------  ##

.PHONY: list

list:;
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##
##                          Show project's banner                             ##
##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:;
	if [ -f ${APP_LOGO} ]; then cat ${APP_LOGO}; fi

##  ------------------------------------------------------------------------  ##

.PHONY: rights

rights:;
	sudo find . -type f -exec chmod 664 {} 2>/dev/null \;
	sudo find . -type d -exec chmod 775 {} 2>/dev/null \;
	sudo find . -type f -name "*.sh" -exec chmod a+x {} 2>/dev/null \;
	sudo find . -type f -name "artisan" -exec chmod a+x {} 2>/dev/null \;

##  ------------------------------------------------------------------------  ##
