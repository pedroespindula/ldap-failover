FROM ubuntu:18.04

WORKDIR /ldap

RUN echo 'slapd/root_password password password' | debconf-set-selections &&\
  echo 'slapd/root_password_again password password' | debconf-set-selections

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  slapd \
  ldap-utils \
 && rm -rf /var/lib/apt/lists/*

COPY ./backup-ldap.sh ./backup-ldap.sh

CMD ["./backup-ldap.sh", "/ldap/backup", "lsd-ldap-load-balancer-2933abfef809e890.elb.us-east-1.amazonaws.com"]
