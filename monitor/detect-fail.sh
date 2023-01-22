#!/bin/bash

set -e

SUCCESS=0
ERROR=1

TIMEOUT=1

echo "VERSION: 1.1.0"

echo "Detecting LDAP failure on host ${LDAP_HOST} on port ${LDAP_PORT}"
result=$(ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" -b "${LDAP_QUERY}" -l $TIMEOUT -LLL &> /dev/null && echo ${SUCCESS} || echo ${ERROR})

if [ $result -eq ${ERROR} ] 
then
  echo "Failure detected!"
  echo "Creating the failover..."
  # cd /home/pedro/repos/ufcg/tcc/ldap/application/terraform/applications/ecs
  # terraform apply -auto-approve
  echo "Creation finished!"
else
  echo "Application is running OK!"
fi
