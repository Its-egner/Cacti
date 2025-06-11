# Introducing the dockerfile

FROM ubuntu:24.04

LABEL maintainer "admin@its-egner.de"
LABEL version "0.1"
LABEL description "Docker container for Cacti Monitoring"

# set environment variables



ARG CACTI_DB_HOST
ARG CACTI_DB_USER
ARG CACTI_DB_PASS
ARG CACTI_DB_NAME
ARG TZ

ENV LANG=en_US.UTF-8
ENV TZ=$TZ
ENV CACTI_DB_HOST=$CACTI_DB_HOST
ENV CACTI_DB_USER=$CACTI_DB_USER
ENV CACTI_DB_PASS=$CACTI_DB_PASS
ENV CACTI_DB_NAME=$CACTI_DB_NAME

# ensure apt will not ask for things interactively
ARG DEBIAN_FRONTEND=noninteractive

# update & install base packages
RUN apt update && \
    apt upgrade -y && \
    apt install -y  cron \
                    locales \
                    supervisor \
                    curl \
                    wget \
                    vim \
                    snmp \
                    openssl \
                    iproute2 \
                    iputils-ping \
                    fping \
                    git


# install observium required packages
RUN apt install -y  libapache2-mod-php \
                    php-cli \
                    php-mysql \
                    php-gd \
                    php-json \
                    php-bcmath \
                    php-mbstring \
                    php-opcache \
                    php-curl \
                    php-apcu \
                    php-pear \
		    php-net-socket \
		    php-intl \
		    php-imap \
		    php-memcache \
		    php-pspell \
		    php-tidy \
		    php-xmlrpc \
		    php-snmp \
		    php-gmp \
		    php-xml \
		    php-common \
		    php-ldap \
                    libphp-phpmailer \
                    libvirt-clients \
                    mysql-client \
                    rrdtool \
                    subversion \
                    whois \
                    mtr-tiny \
                    ipmitool \
                    graphviz \
                    imagemagick \
                    apache2 \
                    python3-mysqldb \
                    python3-pymysql \
                    python-is-python3

# cleanup
RUN apt clean && \
    rm -f /etc/apache2/sites-available/* \
       /etc/cron.d/* \
       /etc/cron.hourly/* \
       /etc/cron.daily/* \
       /etc/cron.weekly/* \
       /etc/cron.monthly/* \
       /etc/logrotate.d/* \
       /etc/supervisord/conf.d/* && \
    rm -fr /var/log/* && \
    mkdir /var/log/apache2

# set locale
RUN locale-gen $LANG

WORKDIR /var/www/html
RUN git clone -b 1.2.x https://github.com/Cacti/cacti.git
RUN chown -R www-data:www-data /var/www/html/cacti
RUN cp /var/www/html/cacti/include/config.php.dist /var/www/html/cacti/include/config.php

COPY init-db.sh /var/www/html/init-db.sh
RUN chmod 700 /var/www/html/init-db.sh

COPY cacti-init.sh /root/cacti-init.sh
RUN chmod a+x /root/cacti-init.sh

COPY timezone.sql  /var/www/html/cacti/timezone.sql
RUN chmod 644 /var/www/html/cacti/timezone.sql

# configure php modules
RUN phpenmod mcrypt

# setup apache configuration and modules
COPY cacti-web.conf /etc/apache2/sites-available/000-default.conf
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork && \
    a2enmod php8.3 && \
    a2enmod rewrite && \
    chmod 644 /etc/apache2/sites-available/000-default.conf

# configure cron and logrotate
COPY cacti-cron.conf  /etc/cron.d/cacti-poller
RUN chmod 644 /etc/cron.d/cacti-poller

# configure entry point
COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcp port
EXPOSE 80/tcp

# set volumes
#VOLUME ["/var/www/html/cacti/log","/var/www/html/cacti/rra","/var/www/html/cacti/plugins/"]
