FROM php:5.6-apache
MAINTAINER kmd2kmd

ENV PHPIPAM_SOURCE https://github.com/phpipam/phpipam/archive
ENV PHPIPAM_VERSION 1.3
ENV WEB_REPO /var/www/html

# Install required deb packages
RUN apt-get update && \
	apt-get install -y git snmp php-pear php5-curl php5-mysql php5-json php5-gmp php5-mcrypt php5-ldap php5-gd php5-snmp libsnmp-dev libjpeg-dev libpng-dev libvpx-dev libgmp-dev libmcrypt-dev && \
	rm -rf /var/lib/apt/lists/*

# Configure apache and required PHP modules
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install pdo_mysql && \
	docker-php-ext-install gettext && \
	docker-php-ext-install pcntl && \
	docker-php-ext-install sockets && \
	docker-php-ext-install gd && \
	docker-php-ext-install snmp && \
	ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && \
	docker-php-ext-configure gmp --with-gmp=/usr/include/x86_64-linux-gnu && \
	docker-php-ext-install gmp && \
    docker-php-ext-install mcrypt && \
	echo ". /etc/environment" >> /etc/apache2/envvars && \
	a2enmod rewrite

COPY php.ini /usr/local/etc/php/

# copy phpipam sources to web dir
ADD ${PHPIPAM_SOURCE}/${PHPIPAM_VERSION}.tar.gz /tmp
RUN mv /tmp/phpipam-${PHPIPAM_VERSION}/* ${WEB_REPO}/

# copy phpipam crontab
COPY ipam /etc/cron.d/

# Use system environment variables into config.php
RUN cp ${WEB_REPO}/config.dist.php ${WEB_REPO}/config.php && \
    sed -i -e "s/\['host'\] = 'localhost'/\['host'\] = 'mysql'/" \
    -e "s/\['user'\] = 'phpipam'/\['user'\] = 'root'/" \
    -e "s/\['pass'\] = 'phpipamadmin'/\['pass'\] = getenv(\"MYSQL_ENV_MYSQL_ROOT_PASSWORD\")/" \
	${WEB_REPO}/config.php

EXPOSE 80
