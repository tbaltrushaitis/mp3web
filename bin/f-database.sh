#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##                f-database.sh:    Database Operations                       ##
##  ------------------------------------------------------------------------  ##

##  Provide:
##      db_backup
##      db_create

##  ENV VARS used:
##      BACK_PATH
##      DATE
##      DB_HOST
##      DB_NAME
##      DB_USER
##      DB_PASS

##  ------------------------------------------------------------------------  ##
##                                   BACKUP                                   ##
##  ------------------------------------------------------------------------  ##

function db_backup {
  splash "\n----------------  BACKUP DATABASE and TABLES  ------------------\n";
  mkdir -p ${BACK_PATH}

  printf "\n================================================================\n";
  printf "[$FUNCNAME] BACKUP OF FULL DATABASE ${DB_NAME} ... ";
  mysqldump ${DB_NAME} > "${BACK_PATH}${DATE}.${DB_NAME}.sql"
  printf "[$FUNCNAME] DONE\n";
  printf "==================================================================\n";

  printf "[$FUNCNAME] PER TABLE BACKUP: \n";
  printf "=============================\n";
  for TABLE in $(mysql -e "USE ${DB_NAME}; SHOW TABLES;" | grep -v "Tables" | sort)
      do
          printf "${TABLE} ... ";
          mysqldump ${DB_NAME} ${TABLE} > "${BACK_PATH}${DATE}.${DB_NAME}.${TABLE}.sql"
          printf "DONE\n";
      done
  splash "[$FUNCNAME] FINISHED: PER TABLE BACKUP\n\n";
}


##  ------------------------------------------------------------------------  ##
##                          CREATE DATABASE AND USER                          ##
##  ------------------------------------------------------------------------  ##

function db_create {
  printf "\n  -------------------------  CREATE DATABASE AND USER --------------------------\n";

  mysql -e "DROP USER '${DB_USER}'@'${DB_HOST}';" 2&>1 >/dev/null
  mysql -e "CREATE USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"
  mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"
  mysql -e "CREATE DATABASE ${DB_NAME};"
  mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
  mysql -e "FLUSH PRIVILEGES;"
  mysql -e "SHOW GRANTS FOR ${DB_USER}@${DB_HOST};"

  printf "USER ${DB_USER}@${DB_HOST} and DATABASE ${DB_NAME} RECREATED \n\n";
  printf "======================================================\n";
}
