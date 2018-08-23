#!/bin/sh -x
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/$1.conf;DIR=$HOME/environment;
if [ ! -f $CONF ];then
#read -p "SITE (default name: $1) = " SITE;
	SITE=${SITE:-"$1"};echo SITE=$SITE>>$CONF
#read -p "REPS (y/n) = " REPS;
	REPS=${REPS:-n};echo REPS=$REPS>>$CONF
#read -p "VERSION (2.x.y: please change it if the default value $VERSION is not appropriate) = " VERSION;
	echo VERSION=$VERSION>>$CONF
read -p "ASDA (password: please leave it blank ONLY for a new subsite) = " ASDA;
	ASDA=${ASDA:-NOPASSWORD};echo ASDA=$ASDA>>$CONF
#read -p "URL (default https://ec.europa.eu/$SITE) = " URL;URL=${URL:-"https://ec.europa.eu/$SITE"};
	echo URL=$URL>>$CONF
REP0=$([ $REPS = y ]&&echo reps-$SITE-reference||echo $SITE-reference);#read -p "REPO (default $REP0) = " REPO;
	REPO=${REPO:-"$REP0"};echo REPO=$REPO>>$CONF
#read -p "GITHUB REPO (https://github.com/ec-europa/$REPO.git change the default if necessary) = " HTTPS;
	HTTPS=${HTTPS:-"https://github.com/ec-europa/$REPO.git"};echo HTTPS=$HTTPS>>$CONF
#read -p "BRANCH (toolkit/upgrade: change the default if necessary but be careful the branch has toolkit) = " BRANCH;
	BRANCH=${BRANCH:-"toolkit/upgrade"};echo BRANCH=$BRANCH>>$CONF
alias drush="$DIR/$REPO/toolkit/drush -r build";echo alias $(alias drush)>>$CONF
alias phing="$DIR/$REPO/toolkit/phing";echo alias $(alias phing)>>$CONF
fi
echo "You have just configured your environment with the following values:";cat $CONF
echo
echo "If there is something you want to change (version, URL, repository...)"
echo "then before continuing with the process"
echo "please edit the following configuration file: $CONF" 
echo
read -p "Press ENTER when the file configuration is ready and you want to continue" ENTER
