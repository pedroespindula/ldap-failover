#!/bin/bash

set -e

SUCCESS=0
ERROR=1

RETRIES=5
TIMEOUT=1

next-lambda-invocation() {
  REQUEST_ID=$(curl -X GET -sI "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next" | awk -v FS=": " '/^Lambda-Runtime-Aws-Request-Id/{print $2}')

  echo "REQUEST_ID: ${REQUEST_ID}"

  URL="http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${REQUEST_ID%$'\r'}/response"

  echo "URL: ${URL}"

  curl -X POST "$URL" -d "SUCCESS"
}

detect-failure() {
  ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" -b "${LDAP_QUERY}" -l $TIMEOUT -LLL
}

backoff() {
  TRIES=$1
  
  # EXPONENTIAL BACKOFF
  echo $(( 2 ** ($TRIES - 1) ))
}

create-failover() {
  cp -r ./terraform/ /tmp
  cd /tmp/terraform/resources/app/
  terraform init -no-color -reconfigure
  terraform apply -auto-approve -no-color
}

for counter in $(seq 1 $RETRIES); do
  echo "Detecting failure on host ${LDAP_HOST} on port ${LDAP_PORT}"

  result=$(detect-failure &> /dev/null && echo ${SUCCESS} || echo ${ERROR})

  if [ $result -eq ${SUCCESS} ]; then
    echo "Application is running OK!"
    break
  fi

  echo "Application is not responding"
  SLEEP_TIME=$(backoff counter)
  echo "Waiting $SLEEP_TIME seconds to try again... (tries: $counter)"
  sleep $SLEEP_TIME
done

if [ $result -eq ${ERROR} ] 
then
  echo "Failure detected!"
  echo "Creating the failover..."
  create-failover
  echo "Creation finished!"
fi

if [ ! -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  echo "Finishing lambda execution"
  next-lambda-invocation
fi

exit 0
