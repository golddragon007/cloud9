#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
getopts ":hdmpsc:n:e:r:" ACTION
case "$ACTION" in
h) cat $CLOUD/README.md;;
d) sudo service httpd stop;;
m) $CLOUD/minimal.sh;$CLOUD/system.sh;;
p) $CLOUD/system.sh;$CLOUD/php.sh;;
s) $CLOUD/system.sh;$CLOUD/php.sh;$CLOUD/basic.sh;$CLOUD/native.sh;;
c) [ ! -f $CONF ]&&$CLOUD/system.sh;$CLOUD/php.sh;$CLOUD/basic.sh;$CLOUD/native.sh;
	$CLOUD/configure.sh $OPTARG;$CLOUD/clone.sh $OPTARG;$CLOUD/install.sh $OPTARG clone;;
n) [ ! -f $CONF ]&&$CLOUD/system.sh;$CLOUD/php.sh;$CLOUD/basic.sh;$CLOUD/native.sh;
	$CLOUD/configure.sh $OPTARG;$CLOUD/install.sh $OPTARG clean;;
e) source $CONF;source $CONFD/$OPTARG.conf;sudo service httpd restart;
	echo You can access your website through this URL\:;awk '/^project.url.base/{print $3}' $DIR/$REPO/$FILE;;
r) source $CONF;source $CONFD/$OPTARG.conf;rm -rf $DIR/$REPO $CONFD/$OPTARG.conf;;
:) echo "The option -$OPTARG requires the name of the subsite as an argument";;
\?) echo "Invalid option: -$OPTARG";;
esac
