#!/bin/sh
set -e
DIR=$HOME/environment
case $2 in
clone) for x in {0..3};do source $DIR/cloud9/toolkit.$x;done;;
rebuild) for x in 0 1 3;do source $DIR/cloud9/toolkit.$x;done;;
download) for x in {0..2};do source $DIR/cloud9/toolkit.$x;done;;
purge) source $DIR/cloud9/toolkit.0;rm -rf $DIR/$REPO $DIR/cloud9/conf.d/$SITE.conf;;
enable) source $DIR/cloud9/toolkit.0;sudo sed -i "/build/s/environment.*build/environment\/$REPO\/build/" $HTTP;sudo service httpd restart;;
esac
