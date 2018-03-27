#!/bin/sh
set -e;trap "echo Something went wrong... the script $0 has been aborted" ERR
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/cloud9.conf;source $KONF;source $CONF/$1.conf
cd $DIR;[ -d $REPO ]||mkdir $REPO;cd $REPO;set +e;rm *;mkdir RESOURCES;mv resources/patches RESOURCES/;mv resources/site.make RESOURCES/;mv resources/composer.json RESOURCES/;rm -r docs/ resources/ src/ tests/;set -e;composer create-project ec-europa/subsite temp dev-master --no-interaction;set +e;mv temp/* .;rmdir temp/;if [ ! -d lib/modules/custom ];then mkdir lib/custom/;mv lib/modules/* lib/custom;mv lib/custom/features lib/features;mv lib/custom lib/modules;mv lib/features lib/modules;fi;mv RESOURCES/* resources/;rmdir RESOURCES;set -e
echo "project.url.base = https://$ENVIRONMENT_ID.vfs.cloud9.$REGION_ID.amazonaws.com">>$FILE
echo "project.url.production = $URL">>$FILE
echo "project.id = $SITE">>$FILE
echo "project.name = Subsite $SITE">>$FILE
echo "platform.package.version = $VERSION">>$FILE
echo "db.host = 127.0.0.1">>$FILE
echo "share.path = /tmp/cache">>$FILE
echo "phpcs.reports = full">>$FILE
echo "behat.formatter.name = pretty">>$FILE
echo "db.dl.password = $ASDA">>$FILE
echo 'db.dl.username = ${project.id}'>>$FILE
echo 'db.name = ${project.id}'>>$FILE
echo 'behat.base_url = ${project.url.base}'>>$FILE
cd $DIR/$REPO;for x in httpd mysqld;do sudo service $x stop;done;phing build-platform;for x in mysqld;do sudo service $x start;done;rm resources/composer.lock;phing build-subsite-dev;phing install-$CLEAN
sed -i "/ec2-user/s/\/home\/ec2-user\/environment\/$REPO\/build\///" build/sites/default/settings.php
sudo sed -i "/build/s/environment.*build/environment\/$REPO\/build/" $HTTP
sudo sed -i "/var\/www\/html/s/var\/www\/html/home\/ec2-user\/environment\/$REPO\/build/" $HTTP
sudo sed -i "/var\/www/s/var\/www/home\/ec2-user\/environment/" $HTTP
sudo sed -i "/User apache/s/apache/ec2-user/" $HTTP
sudo sed -i "/Group apache/s/apache/ec2-user/" $HTTP
sudo sed -i "/AllowOverride None/s/AllowOverride None/AllowOverride All/" $HTTP
sudo sed -i "/AllowOverride none/s/AllowOverride none/AllowOverride All/" $HTTP
