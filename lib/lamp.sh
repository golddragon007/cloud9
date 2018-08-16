#!/bin/sh -x
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
if ! $(grep -q PHP $CONF);then
read -p "PHP (default memory limit: 256M) = " PHP;PHP=${PHP:-256M};echo PHP=$PHP>>$CONF
fi
YUM=/tmp/yum.list;sudo yum update -y;sudo yum -y remove mysql55*;yum list installed>$YUM;
	for x in php56 mysql56-server;do grep -q $x $YUM||sudo yum -y install $x;done
	sudo sed -i "/\[mysqld\]/s/$/\\nmax_allowed_packet=64M/" /etc/my.cnf
	for x in httpd mysqld;do sudo chkconfig $x on;sudo service $x restart;done
	php --version;mysqld --version;httpd -v
PHP=$(grep PHP $CONF|cut -d= -f2);sudo sed -i "/memory_limit/s/=.*$/= $PHP/" /etc/php.ini
BIN=/usr/bin;LOCAL=/usr/local/bin;
	PACK=composer
	if [ ! -f $BIN/$PACK ];then
	URL=https://get$PACK.org/installer 
	sudo curl -sS https://get$PACK.org/installer|sudo php;
	sudo mv $PACK.phar $LOCAL/$PACK;sudo ln -s $LOCAL/$PACK $BIN/$PACK;$PACK --version
	fi
	PACK=drush
	if [ ! -f $BIN/$PACK ];then
	URL=https://github.com/$PACK-ops/$PACK/releases/download/8.1.15/$PACK.phar
	curl --silent $URL -L --output $PACK.phar;chmod +x $PACK.phar;
	sudo mv $PACK.phar $LOCAL/$PACK;sudo ln -s $LOCAL/$PACK $BIN/$PACK;$PACK --version
	fi
if ! $(grep -q HTTPD $CONF);then
read -p "HTTPD (default Apache configuration folder: /etc/httpd/conf.d) = " HTTPD
	HTTPD=${HTTPD:-/etc/httpd/conf.d};echo HTTPD=$HTTPD>>$CONF
fi
