#!/bin/bash

date

aws s3 sync s3://lsd-ldap-backup/ /ldap/conf/

rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
slapadd -F /etc/ldap/slapd.d -b cn=config -l /ldap/conf/config.ldif
slapadd -F /etc/ldap/slapd.d -b dc=lsd,dc=ufcg,dc=edu,dc=br -l /ldap/conf/users.ldif
chown -R openldap:openldap /etc/ldap/slapd.d/
chown -R openldap:openldap /var/lib/ldap/

CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * *"}

echo "${CRON_SCHEDULE} bash /ldap/backup-ldap.sh >> /ldap/backup-ldap.logs 2>&1" | crontab -

printenv | grep -v "no_proxy" >> /etc/environment

cron

exec "$@"
