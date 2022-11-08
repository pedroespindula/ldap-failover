#!/bin/bash

set -e

SLAPCAT=/usr/sbin/slapcat
BACKUP_PATH=/home/ubuntu/
CURRENT_DATE=$(date +"%d-%m-%Y")
CONFIG_PATH=${BACKUP_PATH}/config-${CURRENT_DATE}.ldif
ENTRIES_PATH=${BACKUP_PATH}/ldap-${CURRENT_DATE}.ldif

nice ${SLAPCAT} -b cn=config > ${CONFIG_PATH}
nice ${SLAPCAT} -b dc=lsd,dc=ufcg,dc=edu,dc=br > ${ENTRIES_PATH}
chown root:root ${BACKUP_PATH}/*
chmod 600 ${BACKUP_PATH}/*.ldif
