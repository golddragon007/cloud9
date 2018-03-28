#!/bin/sh -x
set -e
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/cloud9.conf
case $2 in
clean) $CLOUD/system.sh;$CLOUD/native.sh;$CLOUD/configure.sh $1;$CLOUD/install.sh $1 clean;;
clone) $CLOUD/system.sh;$CLOUD/native.sh;$CLOUD/configure.sh $1;$CLOUD/clone.sh $1;$CLOUD/install.sh $1 clone;;
purge) source $CONF/$1.conf;rm -rf $DIR/$REPO $CONF/$1.conf;; 
enable) source $KONF;source $CONF/$1.conf;sudo sed -i "/build/s/environment.*build/environment\/$REPO\/build/" $HTTP;sudo service httpd restart;echo You can access your website through this URL\:;echo;awk '/^project.url.base/{print $3}' $DIR/$REPO/$FILE;;
disable) sudo service httpd stop;;
*) $CLOUD/system.sh;;
esac
