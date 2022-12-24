tag = test

echo:
	echo ${AWS_ACCOUNT_ID} ${AWS_SECRET_ACCESS_KEY} ${AWS_ACCESS_KEY_ID}

only-init:
	cd ./terraform/resources/ && \
	cd ./remote-tfstate && \
	terraform apply -auto-approve && \
	cd ../backup-bucket && \
	terraform apply -auto-approve && \
	cd ../ecr && \
	terraform apply -auto-approve

only-build:
	cd ./application/ && \
	docker build . -t lsd-ldap:${tag} && \
	docker tag lsd-ldap:${tag} ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/lsd-ldap:latest && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com && \
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/lsd-ldap:latest

build: only-init only-build

only-deploy:
	cd ./terraform/resources/ecs && \
	terraform apply -auto-approve

deploy: only-init only-build only-deploy

