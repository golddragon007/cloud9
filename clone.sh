#!/bin/sh -x
set -e
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/cloud9.conf;source $KONF;source $CONF/$1.conf
cd $DIR;[ -d $REPO ]&&rm -rf $REPO
git clone $HTTPS||(while ! git clone $HTTPS;do echo;echo Please try again\:;done);cd $REPO;git checkout -b toolkit/upgrade
