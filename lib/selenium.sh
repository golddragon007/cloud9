#!/bin/sh
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
if ! $(grep -q FILE $CONF);then
#read -p "FILE (default Developer configuration file: build.develop.props) = " FILE
        FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$CONF
fi
if [ ! -f $HOME/environment/cloud9/conf.d/selenium.yml ];then
	cd $HOME/environment/cloud9/conf.d;touch selenium.yml;
	echo 'version: "3"'>>selenium.yml;echo 'services:'>>selenium.yml;echo '        selenium:'>>selenium.yml;
	echo '                image: selenium/standalone-chrome'>>selenium.yml;echo '                ports:'>>selenium.yml;
	echo '                        - "4444:4444"'>>selenium.yml;
	set +e;docker swarm leave --force;sudo service docker restart;set -e
	docker swarm init;docker stack deploy -c selenium.yml selenium
fi
