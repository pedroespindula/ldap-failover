#!/bin/bash

set -e

SLAPADD=/usr/sbin/slapadd
BACKUP_PATH=/ldap
CONFIG_PATH=${BACKUP_PATH}/config.ldif
ENTRIES_PATH=${BACKUP_PATH}/users.ldif

if [ -n "$(ls -l /var/lib/ldap/* 2>/dev/null)" -o -n "$(ls -l /etc/ldap/slapd.d/* 2>/dev/null)" ]; then
    echo Run the following to remove the existing db:
    echo systemctl stop slapd.service
    echo rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
    exit 1
fi

systemctl stop slapd.service
slapadd -F /etc/ldap/slapd.d -b cn=config -l ${CONFIG_PATH}
slapadd -F /etc/ldap/slapd.d -b dc=lsd,dc=ufcg,dc=edu,dc=br -l ${ENTRIES_PATH}
chown -R openldap:openldap /etc/ldap/slapd.d/
chown -R openldap:openldap /var/lib/ldap/
systemctl start slapd.service
