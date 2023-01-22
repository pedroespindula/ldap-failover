#!/bin/bash

set -e

SUCCESS=0
ERROR=1

TIMEOUT=1

echo "VERSION: 1.2.0"

echo "Detecting LDAP failure on host ${LDAP_HOST} on port ${LDAP_PORT}"
result=$(ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" -b "${LDAP_QUERY}" -l $TIMEOUT -LLL &> /dev/null && echo ${SUCCESS} || echo ${ERROR})

if [ $result -eq ${ERROR} ] 
then
  echo "Failure detected!"
  echo "Creating the failover..."
  cp -r ./terraform/ /tmp
  cd /tmp/terraform/resources/ldap/
  terraform init -no-color
  terraform apply -auto-approve -no-color
  # cd /home/pedro/repos/ufcg/tcc/ldap/application/terraform/applications/ecs
  # terraform apply -auto-approve
  echo "Creation finished!"
  RESPONSE="{\"statusCode\": 200, \"body\": \"Creation Finished\"}"
  echo $RESPONSE
else
  echo "Application is running OK!"
  RESPONSE="{\"statusCode\": 200, \"body\": \"Application is running OK!\"}"
  echo $RESPONSE
fi
