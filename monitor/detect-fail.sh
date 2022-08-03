#!/bin/bash

set -e

SUCCESS=0
ERROR=1

TIMEOUT=1

next-lambda-invocation() {
  REQUEST_ID=$(curl -X GET -sI "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next" | awk -v FS=": " '/^Lambda-Runtime-Aws-Request-Id/{print $2}')

  echo "REQUEST_ID: ${REQUEST_ID}"

  URL="http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${REQUEST_ID%$'\r'}/response"

  echo "URL: ${URL}"

  curl -X POST "$URL" -d "SUCCESS"
}

echo "VERSION: 1.3.2"

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
else
  echo "Application is running OK!"
fi

if [ ! -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  echo "Finishing lambda execution"
  next-lambda-invocation
fi

exit 0
