#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf;LIB=$CLOUD/lib
$LIB/pubkey.sh;getopts ":hazdmptc:n:e:r:" ACTION
case "$ACTION" in
h) cat README.md;;
a) grep IP= $CONF;;
z) sudo growpart /dev/xvda 1;sudo resize2fs /dev/xvda1;;
d) sudo service httpd stop;;
m) $LIB/system.sh;$LIB/ip.sh;$LIB/minimal.sh;;
p) $LIB/system.sh;$LIB/ip.sh;$LIB/minimal.sh;$LIB/lamp.sh;;
t) $LIB/system.sh;$LIB/ip.sh;$LIB/minimal.sh;$LIB/lamp.sh;$LIB/misc.sh;;
c) [ ! -f $CONF ]&&($LIB/system.sh;$LIB/ip.sh;$LIB/minimal.sh);$LIB/lamp.sh;$LIB/misc.sh;
	$LIB/configure.sh $OPTARG;$LIB/clone.sh $OPTARG;$LIB/install.sh $OPTARG clone;;
n) [ ! -f $CONF ]&&($LIB/system.sh;$LIB/ip.sh;$LIB/minimal.sh);$LIB/lamp.sh;$LIB/misc.sh;
	$LIB/configure.sh $OPTARG;$LIB/install.sh $OPTARG clean;;
e) source $CONF;source $CONFD/$OPTARG.conf;sudo service httpd restart;
	echo You can access your website through this URL\:;awk '/^project.url.base/{print $3}' $DIR/$REPO/$FILE;;
r) source $CONF;source $CONFD/$OPTARG.conf;rm -rf $DIR/$REPO $CONFD/$OPTARG.conf;;
:) echo "The option -$OPTARG requires the name of the subsite as an argument";;
\?) echo "Invalid option: -$OPTARG";echo "Please use -h option to get help";;
esac
