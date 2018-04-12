#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
YUM=/tmp/yum.list;sudo yum update -y;sudo yum -y remove mysql55*;sudo yum list installed>>$YUM;for x in mysql56-server php56 php56-pecl-xdebug phpMyAdmin;do grep -q $x $YUM||sudo yum -y install $x;done
DEBUG=/etc/php-5.6.d/15-xdebug.ini;grep -q "^xdebug.remote_enable = 1" $DEBUG||(sudo sed -i /^xdebug.remote_enable/d $DEBUG;sudo sed -i "/^;xdebug.remote_enable/axdebug.remote_enable = 1" $DEBUG)
PHP=$(grep PHP $CONF|cut -d= -f2);sudo sed -i "/memory_limit/s/=.*$/= $PHP/" /etc/php.ini
for x in httpd mysqld;do sudo chkconfig $x on;sudo service $x stop;done
ls $HOME/environment/cloud9/conf.d/selenium.yml||(cd $HOME/environment/cloud9/conf.d;touch selenium.yml;echo 'version: "3"'>>selenium.yml;echo 'services:'>>selenium.yml;echo '        selenium:'>>selenium.yml;echo '                image: selenium/standalone-chrome'>>selenium.yml;echo '                ports:'>>selenium.yml;echo '                        - "4444:4444"'>>selenium.yml;docker swarm init;docker stack deploy -c selenium.yml selenium)
BIN=/usr/bin;LOCAL=/usr/local/bin;sudo yum update -y;ls $BIN/composer||(sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;sudo ln -s $LOCAL/composer $BIN/composer)
