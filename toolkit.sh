#!/bin/sh
set -e
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/cloud9.conf
getopts ":shde:r:c:n:" ACTION
case "$ACTION" in
s) $CLOUD/system.sh;$CLOUD/basic.sh;;
h) cat $CLOUD/README.md;;
d) sudo service httpd stop;;
e) source $KONF;source $CONF/$OPTARG.conf;sudo sed -i "/build/s/environment.*build/environment\/$REPO\/build/" $HTTP;sudo service httpd restart;echo You can access your website through this URL\:;awk '/^project.url.base/{print $3}' $DIR/$REPO/$FILE;;
r) source $CONF/$OPTARG.conf;rm -rf $DIR/$REPO $CONF/$OPTARG.conf;;
c) $CLOUD/system.sh;$CLOUD/basic.sh;$CLOUD/native.sh;$CLOUD/configure.sh $OPTARG;$CLOUD/clone.sh $OPTARG;$CLOUD/install.sh $OPTARG clone;;
n) $CLOUD/system.sh;$CLOUD/basic.sh;$CLOUD/native.sh;$CLOUD/configure.sh $OPTARG;$CLOUD/install.sh $OPTARG clean;;
:) echo "The option -$OPTARG requires the name of the subsite as an argument";;
\?) echo "Invalid option: -$OPTARG";;
esac
