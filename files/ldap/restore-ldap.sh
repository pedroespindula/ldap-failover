#!/bin/bash

set -e

SLAPADD=/usr/sbin/slapadd
BACKUP_PATH=/home/ubuntu/
CONFIG_PATH=${BACKUP_PATH}/config.ldif
ENTRIES_PATH=${BACKUP_PATH}/ldap-08-10-2021.ldif

if [ -n "$(ls -l /var/lib/ldap/* 2>/dev/null)" -o -n "$(ls -l /etc/ldap/slapd.d/* 2>/dev/null)" ]; then
    echo Run the following to remove the existing db:
    echo sudo systemctl stop slapd.service
    echo sudo rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
    exit 1
fi

sudo systemctl stop slapd.service
sudo slapadd -F /etc/ldap/slapd.d -b cn=config -l ${CONFIG_PATH}
sudo slapadd -F /etc/ldap/slapd.d -b dc=lsd,dc=ufcg,dc=edu,dc=br -l ${ENTRIES_PATH}
sudo chown -R openldap:openldap /etc/ldap/slapd.d/
sudo chown -R openldap:openldap /var/lib/ldap/
sudo systemctl start slapd.service
