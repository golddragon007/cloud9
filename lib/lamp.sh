#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
if ! $(grep -q PHP $CONF);then
read -p "PHP (default memory limit: 256M) = " PHP;PHP=${PHP:-256M};echo PHP=$PHP>>$CONF
fi
YUM=/tmp/yum.list;sudo yum update -y;sudo yum -y remove mysql55*;yum list installed>$YUM;
	for x in php56 mysql56-server;do grep -q $x $YUM||sudo yum -y install $x;done
PHP=$(grep PHP $CONF|cut -d= -f2);sudo sed -i "/memory_limit/s/=.*$/= $PHP/" /etc/php.ini
BIN=/usr/bin;LOCAL=/usr/local/bin;
	if [ ! -f $BIN/composer ];then
	sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;
	sudo ln -s $LOCAL/composer $BIN/composer
	fi
if ! $(grep -q HTTPD $CONF);then
read -p "HTTPD (default Apache configuration folder: /etc/httpd/conf.d) = " HTTPD
	HTTPD=${HTTPD:-/etc/httpd/conf.d};echo HTTPD=$HTTPD>>$CONF
fi
for x in httpd mysqld;do sudo chkconfig $x on;sudo service $x stop;done
