#!/bin/bash

set -e

BACKUP_PATH=/backup

LDAP_USERS_DC="dc=lsd,dc=ufcg,dc=edu,dc=br"
LDAP_CONFIG_DC="cn=config"

BUCKET_NAME="lsd-ldap-backup"

CONFIG_PATH=${BACKUP_PATH}/config.ldif
ENTRIES_PATH=${BACKUP_PATH}/users.ldif

mkdir -p ${BACKUP_PATH}

echo "Recuperando os usuários do LDAP"

/usr/sbin/slapcat -b ${LDAP_USERS_DC} > ${ENTRIES_PATH}

echo "Usuários recuperados com sucesso! Segue uma amostra do arquivo:"
head ${ENTRIES_PATH}

echo "Recuperando as configurações do LDAP"

/usr/sbin/slapcat -b ${LDAP_CONFIG_DC} > ${CONFIG_PATH}

echo "Configurações recuperadas com sucesso! Segue uma amostra do arquivo:"
head ${CONFIG_PATH}

echo "Enviando arquivos para o S3"

/usr/local/bin/aws s3 sync ${BACKUP_PATH} s3://${BUCKET_NAME}
