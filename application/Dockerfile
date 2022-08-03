FROM ubuntu:18.04

WORKDIR /ldap

RUN echo 'slapd/root_password password password' | debconf-set-selections &&\
  echo 'slapd/root_password_again password password' | debconf-set-selections

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  slapd \
  ldap-utils \
  python3 \
  python3-pip \
  cron \
  vim \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip && \
    pip3 install --upgrade awscli

COPY conf conf

COPY entrypoint.sh entrypoint.sh

COPY backup-ldap.sh backup-ldap.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["slapd", "-h", "ldap:/// ldapi:/// ldaps:///", "-u", "openldap", "-g", "openldap", "-dStats,Stats2"]
