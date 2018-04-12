#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
YUM=/tmp/yum.list;sudo yum update -y;sudo yum -y remove mysql55*;yum list installed>$YUM;
	for x in php56-pecl-xdebug phpMyAdmin;do grep -q $x $YUM||sudo yum -y install $x;done
DEBUG=/etc/php-5.6.d/15-xdebug.ini;
	if ! $(grep -q "^xdebug.remote_enable = 1" $DEBUG);then
	sudo sed -i /^xdebug.remote_enable/d $DEBUG;sudo sed -i "/^;xdebug.remote_enable/axdebug.remote_enable = 1" $DEBUG
	fi
if [ ! -f $HOME/environment/cloud9/conf.d/selenium.yml ];then
	cd $HOME/environment/cloud9/conf.d;touch selenium.yml;
	echo 'version: "3"'>>selenium.yml;echo 'services:'>>selenium.yml;echo '        selenium:'>>selenium.yml;
	echo '                image: selenium/standalone-chrome'>>selenium.yml;echo '                ports:'>>selenium.yml;
	echo '                        - "4444:4444"'>>selenium.yml;
	set +e;docker swarm leave --force;sudo service docker restart;set -e
	docker swarm init;docker stack deploy -c selenium.yml selenium
fi
for x in httpd mysqld;do sudo service $x stop;done
