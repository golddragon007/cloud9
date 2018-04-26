#!/bin/sh
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
YUM=/tmp/yum.list;sudo yum update -y;sudo yum -y remove mysql55*;yum list installed>$YUM;
	for x in php56-pecl-xdebug phpMyAdmin;do grep -q $x $YUM||sudo yum -y install $x;done
DEBUG=/etc/php-5.6.d/15-xdebug.ini;
	if ! $(grep -q "^xdebug.remote_enable = 1" $DEBUG);then
	sudo sed -i /^xdebug.remote_enable/d $DEBUG;sudo sed -i "/^;xdebug.remote_enable/axdebug.remote_enable = 1" $DEBUG
	fi
