#!/bin/bash

SECURITY_CONF_PATH="/etc/apache2/conf-enabled"
SECURITY_CONF="/security.conf"

DIR_CONF_PATH="/etc/apache2/mods-enabled"
DIR_CONF="/dir.conf"

APACHE2_CONF_PATH="/etc/apache2"
APACHE2_CONF="/apache2.conf"

DEFAULT_000_PATH="/etc/apache2/sites-enabled"
DEFAULT_000="/000-default.conf"

NOW=$(date "+%H%M%d%m%y")

mkdir -p ./backups/$NOW$SECURITY_CONF_PATH ./backups/$NOW$DIR_CONF_PATH ./backups/$NOW$APACHE2_CONF_PATH ./backups/$NOW$DEFAULT_000_PATH

cat $SECURITY_CONF_PATH$SECURITY_CONF > ./backups/$NOW$SECURITY_CONF_PATH$SECURITY_CONF
cat $DIR_CONF_PATH$DIR_CONF > ./backups/$NOW$DIR_CONF_PATH$DIR_CONF
cat $APACHE2_CONF_PATH$APACHE2_CONF > ./backups/$NOW$APACHE2_CONF_PATH$APACHE2_CONF
cat $DEFAULT_000_PATH$DEFAULT_000 > ./backups/$NOW$DEFAULT_000_PATH$DEFAULT_000


echo "backed up to ./backups/$NOW"
