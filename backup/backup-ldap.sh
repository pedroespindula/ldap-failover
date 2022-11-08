#!/bin/bash

set -e

BACKUP_PATH=$1
LDAP_HOST=$2

LDAP_ADMIN_DN="cn=admin,dc=lsd,dc=ufcg,dc=edu,dc=br"
LDAP_ADMIN_PASSWORD="S3nh@P4r4Mud4r"

LDAP_USERS_DC="dc=lsd,dc=ufcg,dc=edu,dc=br"
LDAP_CONFIG_DC="cn=config"

BUCKET_NAME="lsd-ldap-backup"

CONFIG_PATH=${BACKUP_PATH}/config.ldif
ENTRIES_PATH=${BACKUP_PATH}/users.ldif

mkdir -p ${BACKUP_PATH}


ldapsearch -x  \
  -D "${LDAP_ADMIN_DN}" \
  -w "${LDAP_ADMIN_PASSWORD}" \
  -H "ldap://${LDAP_HOST}" \
  -b "${LDAP_CONFIG_DC}" \
  -LLL > ${CONFIG_PATH}
ldapsearch -x  \
  -D "${LDAP_ADMIN_DN}" \
  -w "${LDAP_ADMIN_PASSWORD}" \
  -H "ldap://${LDAP_HOST}" \
  -b "${LDAP_USERS_DC}" \
  -LLL > ${ENTRIES_PATH}


export LDAP_ADMIN_DN="cn=admin,dc=lsd,dc=ufcg,dc=edu,dc=br"
export LDAP_ADMIN_PASSWORD="S3nh@P4r4Mud4r"
export LDAP_USERS_DC="dc=lsd,dc=ufcg,dc=edu,dc=br"
export LDAP_CONFIG_DC="cn=config"
export LDAP_HOST=lsd-ldap-load-balancer-3a99164692c6af58.elb.us-east-1.amazonaws.com

# slapcat -H ${LDAP_HOST} -b cn=config > ${CONFIG_PATH}
# slapcat -H ${LDAP_HOST} -b dc=lsd,dc=ufcg,dc=edu,dc=br > ${ENTRIES_PATH}

aws s3 sync ${BACKUP_PATH} s3://${BUCKET_NAME}
