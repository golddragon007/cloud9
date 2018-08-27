#!/bin/sh -x
set -e
LIB=$(dirname "$(readlink -f "$0")")
CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d
[ -d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
sudo cp $LIB/sysctl.conf /etc/sysctl.d/perf.conf&&sudo sysctl -p $LIB/perf.conf

[ -f $CONF ]&&mv $CONF $CONF.OLD
read -p "GITHUB_USER (Github username) = " GITHUB_USER
GITHUB_USER=${GITHUB_USER:-NOUSER};
echo GITHUB_USER=$GITHUB_USER>>$CONF
read -p "GITHUB USER (Name Surname) = " USER
USER=${USER:-NOUSER}
echo USER=\"$USER\">>$CONF
read -p "GITHUB EMAIL (user@domain) = " EMAIL
EMAIL=${EMAIL:-"NOUSER@NOMAIL"}
echo EMAIL=$EMAIL>>$CONF
REGION_ID=${REGION_ID:-eu-west-1}
echo REGION_ID=$REGION_ID>>$CONF
URL=http://169.254.169.254/latest/meta-data/security-groups;
ENVIRONMENT_ID=$(curl $URL|awk -F'-InstanceSecurityGroup' '{print $1}'|rev|cut -d- -f1|rev);
echo ENVIRONMENT_ID=$ENVIRONMENT_ID
echo ENVIRONMENT_ID=$ENVIRONMENT_ID>>$CONF
DIR=$HOME/environment
echo DIR=$DIR>>$CONF

