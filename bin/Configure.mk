##  ------------------------------------------------------------------------  ##
##                         Configure predefined values                        ##
##  ------------------------------------------------------------------------  ##

# $(info [$(lastword $(MAKEFILE_LIST))])

# include bin/Colors


##  ------------------------------------------------------------------------  ##

.PHONY: gen_rc

BD=./bin
CFG=config

NEW_UUID = $(shell cat /dev/urandom | tr -dc "a-zA-Z0-9_\$\?" | fold -w 16 | head -1)
SECR = $(shell cat /dev/urandom | tr -dc "a-zA-Z0-9_\$\?" | fold -w 64 | head -1)

DB_NAME := mp3web-db-$(NEW_UUID)
DB_USER := mp3web-db-user-$(NEW_UUID)
DB_PASS := $(SECR)

$(info [$(Gray)$(DT)$(NC)] DB_DATABASE [$(White)$(DB_NAME)$(NC)])
$(info [$(Gray)$(DT)$(NC)] DB_USERNAME [$(White)$(DB_USER)$(NC)])
$(info [$(Gray)$(DT)$(NC)] DB_PASSWORD [$(White)$(DB_PASS)$(NC)])

FILE_SRC = $(CFG)/.env.tpl
FILE_DST = $(RC_FILE).$(APP_ENV)
# FILE_DST = $(CFG)/.env.rc

$(info [$(Gray)$(DT)$(NC)] [$(Yellow)FILE_SRC$(NC):$(White)$(FILE_SRC)$(NC)])
$(info [$(Gray)$(DT)$(NC)] [$(Yellow)FILE_DST$(NC):$(Purple)$(FILE_DST)$(NC)])

gen_rc:
	@ sed -e 's/{{DB_NAME}}/$(DB_NAME)/g;' \
		-e 's/{{DB_USER}}/$(DB_USER)/g;' \
		-e 's/{{DB_PASS}}/$(DB_PASS)/g;' \
		$(FILE_SRC) > $(FILE_DST) ;
	@ echo [${Gray}${DT}${NC}] GENERATED ${Yellow}RESOURCE CONFIG${NC}: [${White}${FILE_DST}${NC}]
	# @ cat ${FILE_DST} ;

# @ cp -prvf $(FILE_SRC) $(FILE_DST) \
# @ $(shell cp -prv "$(FILE_SRC)" "$(FILE_DST)") ;
##  ------------------------------------------------------------------------  ##
