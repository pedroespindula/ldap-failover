FROM ubuntu:18.04

WORKDIR /ldap

COPY . .

RUN echo 'slapd/root_password password password' | debconf-set-selections &&\
  echo 'slapd/root_password_again password password' | debconf-set-selections

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  slapd \
  ldap-utils \
 && rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
RUN slapadd -F /etc/ldap/slapd.d -b cn=config -l /ldap/conf/config.ldif
RUN slapadd -F /etc/ldap/slapd.d -b dc=lsd,dc=ufcg,dc=edu,dc=br -l /ldap/conf/users.ldif
RUN chown -R openldap:openldap /etc/ldap/slapd.d/
RUN chown -R openldap:openldap /var/lib/ldap/

CMD ["slapd", "-h", "ldap:/// ldapi:/// ldaps:///", "-u", "openldap", "-g", "openldap", "-dStats,Stats2"]
