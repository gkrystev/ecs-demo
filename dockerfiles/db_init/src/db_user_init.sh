#!/usr/bin/env bash

MYSQL_CMD="mysql --user=$RDS_ROOT_USERNAME --password=$RDS_ROOT_PASSWORD -h $RDS_HOST"

echo "Create database $WEB_APP_DB_NAME"
$MYSQL_CMD -e "CREATE DATABASE IF NOT EXISTS $WEB_APP_DB_NAME"

echo "INFO: Create user $WEB_APP_DB_USERNAME with AWSAuthenticationPlugin enabled"
$MYSQL_CMD -D mysql -e "CREATE USER IF NOT EXISTS $WEB_APP_DB_USERNAME IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS'"

echo "INFO: Grant privileges $WEB_APP_DB_NAME.* on user $WEB_APP_DB_USERNAME"
$MYSQL_CMD -D mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, EVENT, TRIGGER, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EXECUTE ON $WEB_APP_DB_NAME.* TO '$WEB_APP_DB_USERNAME'@'%'"

echo "INFO: Flush database privileges"
$MYSQL_CMD -e "FLUSH PRIVILEGES"

echo "INFO: Execute inifinte loop..."
while true; do sleep 1; done

