FROM ubuntu:18.04 as base

WORKDIR /monitor

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  unzip \
  curl \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip

RUN unzip terraform_1.0.0_linux_amd64.zip

RUN mv terraform /usr/local/bin/

COPY ./terraform/ ./terraform

COPY ./monitor.sh .

CMD ["./monitor.sh"]

# APPLICATION IMAGE CONFIGURATIONS

RUN echo 'slapd/root_password password password' | debconf-set-selections &&\
  echo 'slapd/root_password_again password password' | debconf-set-selections

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  slapd \
  ldap-utils \
 && rm -rf /var/lib/apt/lists/*

