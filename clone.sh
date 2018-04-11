#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf;source $CONF;source $CONFD/$1.conf
cd $DIR;[ -d $REPO ]&&rm -rf $REPO
git clone $HTTPS;cd $REPO;git checkout -b toolkit/upgrade
