FROM ubuntu:latest

RUN apt-get update && apt-get -y upgrade \
&& DEBIAN_FRONTEND=noninteractive \ 
&& apt-get -y install wget zip unzip curl apache2 php7.0 php7.0-mysql libapache2-mod-php7.0

#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
#ENV APACHE_LOG_DIR /var/log/apache2
#ENV APACHE_DOC_ROOT /var/www/greycom

RUN a2enmod php7.0
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

EXPOSE 80

ADD pimcore-config.conf /etc/apache2/sites-enabled/000-default.conf

RUN wget https://www.pimcore.org/download/pimcore-latest.zip -P /tmp/
RUN mkdir /var/www/html/pimcore
RUN unzip /tmp/pimcore-latest.zip -d /var/www/html/pimcore/
RUN chmod -R 765 /var/www/html/pimcore
RUN chown -R www-data:www-data /var/www/html/pimcore
#RUN a2ensite pimcore-config.conf
#RUN a2ensite 000-default.conf
RUN a2enmod rewrite

CMD /usr/sbin/apache2ctl -D FOREGROUND
