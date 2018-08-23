#!/bin/sh
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;[ -d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
sed -i /IP=/d $CONF;URL=http://169.254.169.254/latest/meta-data/public-ipv4;IP=$(curl $URL);echo IP=$IP;echo IP=$IP>>$CONF
