#!/bin/bash

set -e

BACKUP_PATH=/backup

LDAP_ADMIN_DN="cn=admin,dc=lsd,dc=ufcg,dc=edu,dc=br"
LDAP_ADMIN_PASSWORD="S3nh@P4r4Mud4r"

LDAP_USERS_DC="dc=lsd,dc=ufcg,dc=edu,dc=br"
LDAP_CONFIG_DC="cn=config"

BUCKET_NAME="lsd-ldap-backup"

CONFIG_PATH=${BACKUP_PATH}/config.ldif
ENTRIES_PATH=${BACKUP_PATH}/users.ldif

mkdir -p ${BACKUP_PATH}

echo "Recuperando os usuários do LDAP"

ldapsearch -x  \
  -D "${LDAP_ADMIN_DN}" \
  -w "${LDAP_ADMIN_PASSWORD}" \
  -H "ldap://${LDAP_HOST}" \
  -b "${LDAP_USERS_DC}" \
  -LLL > ${ENTRIES_PATH}

ldapsearch -x -H "ldap://ldap.lsd.ufcg.edu.br" -b "ou=users,dc=lsd,dc=ufcg,dc=edu,dc=br" -LLL

echo "Usuários recuperados com sucesso! Segue uma amostra do arquivo:"
head ${ENTRIES_PATH}

echo "Recuperando as configurações do LDAP"

ldapsearch -x  \
  -D "${LDAP_ADMIN_DN}" \
  -w "${LDAP_ADMIN_PASSWORD}" \
  -H "ldap://${LDAP_HOST}" \
  -b "${LDAP_CONFIG_DC}" \
  -LLL > ${CONFIG_PATH}

echo "Configurações recuperadas com sucesso! Segue uma amostra do arquivo:"
head ${CONFIG_PATH}

# slapcat -H ${LDAP_HOST} -b cn=config > ${CONFIG_PATH}
# slapcat -H ${LDAP_HOST} -b dc=lsd,dc=ufcg,dc=edu,dc=br > ${ENTRIES_PATH}

echo "Enviando arquivos para o S3"

aws s3 sync ${BACKUP_PATH} s3://${BUCKET_NAME}
