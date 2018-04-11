#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;-d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
[ -f $CONF ]&&mv $CONF $CONF.OLD
read -p "GITHUB_USER (Github username) = " GITHUB_USER;GITHUB_USER=${GITHUB_USER:-NOUSER};echo GITHUB_USER=$GITHUB_USER>>$CONF
SSH=$HOME/.ssh/authorized_keys;grep -q User $SSH||(echo "#User key:">>$SSH;curl https://github.com/$GITHUB_USER.keys>>$SSH)
read -p "GITHUB USER (Name Surname) = " USER;USER=${USER:-NOUSER};echo USER=\"$USER\">>$CONF
read -p "GITHUB EMAIL (user@domain) = " EMAIL;EMAIL=${EMAIL:-"NOUSER@NOMAIL"};echo EMAIL=$EMAIL>>$CONF
read -p "PHP (default memory limit: 256M) = " PHP;PHP=${PHP:-256M};echo PHP=$PHP>>$CONF
read -p "HTTP (default Apache configuration file: /etc/httpd/conf/httpd.conf) = " HTTP;HTTP=${HTTP:-/etc/httpd/conf/httpd.conf};echo HTTP=$HTTP>>$CONF
#read -p "FILE (default Developer configuration file: build.develop.props) = " FILE;FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$CONF
FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$CONF
#read -p "REGION_ID (default AWS region Ireland: eu-west-1) = " REGION_ID;REGION_ID=${REGION_ID:-eu-west-1};echo REGION_ID=$REGION_ID>>$CONF
REGION_ID=${REGION_ID:-eu-west-1};echo REGION_ID=$REGION_ID>>$CONF
ENVIRONMENT_ID=$(curl http://169.254.169.254/latest/meta-data/security-groups|cut -d\- -f4);echo ENVIRONMENT_ID=$ENVIRONMENT_ID;echo ENVIRONMENT_ID=$ENVIRONMENT_ID>>$CONF
DIR=$HOME/environment;echo DIR=$DIR>>$CONF
git config --global user.name $USER;git config --global user.email $EMAIL
git config --global alias.st 'status'
git config --global alias.ci 'commit'
git config --global alias.br 'branch'
git config --global alias.co 'checkout'
git config --global alias.df 'diff'
git config --global alias.dc 'diff --cached'
git config --global alias.lg 'log -p'
git config --global alias.bra 'branch -a'
