#!/bin/bash

set -e

SUCCESS=0
ERROR=1

TIMEOUT=1
LDAP_PORT=389

echo "Detecting LDAP failure on host ${LDAP_HOST}"
result=$(nc -vz -w ${TIMEOUT} ${LDAP_HOST} ${LDAP_PORT} &> /dev/null && echo ${SUCCESS} || echo ${ERROR})
# result=$(ldapsearch -x -H "ldap://${LDAP_HOST}" -b "${LDAP_QUERY}" -l $TIMEOUT -LLL && echo ${SUCCESS} || echo ${ERROR})

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
