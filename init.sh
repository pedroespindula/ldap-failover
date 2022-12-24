key=$1
secret=$2
account=$3

export AWS_ACCESS_KEY_ID=${key}
export AWS_SECRET_ACCESS_KEY=${secret}
export AWS_ACCOUNT_ID=${account}

tag=test

echo << EOM
ACCOUNT_ID: ${AWS_ACCOUNT_ID}
ACCESS_KEY: ${AWS_ACCESS_KEY_ID}
SECRET: ${AWS_SECRET_ACCESS_KEY} 
EOM

init() {
  cd ./terraform/resources/
  cd ./remote-tfstate
  terraform apply -auto-approve
  cd ../backup-bucket
  terraform apply -auto-approve
  cd ../ecr
  terraform apply -auto-approve
}

build() {
  cd ./application/
  docker build . -t ldap-lsd:${tag}
  docker tag ldap-lsd:${tag} ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/ldap-lsd:latest
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/ldap-lsd:latest
}

deploy() {
  init
  build

  cd ./terraform/resources/ecs
  terraform apply -auto-approve
}

deploy

