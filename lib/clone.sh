#!/bin/sh -x
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf;source $CONF;source $CONFD/$1.conf
cd $DIR;[ -d $REPO ]&&rm -rf $REPO
git clone $HTTPS;cd $REPO;git checkout -b $BRANCH