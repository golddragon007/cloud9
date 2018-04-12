#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/$1.conf;DIR=$HOME/environment;
if [ ! -f $CONF ];then
read -p "SITE (default name: $1) = " SITE;SITE=${SITE:-"$1"};echo SITE=$SITE>>$CONF
read -p "REPS (y/n) = " REPS;REPS=${REPS:-n};echo REPS=$REPS>>$CONF
read -p "VERSION (2.x.y: please change it if the default value 2.3 is not appropriate) = " VERSION;echo VERSION=$VERSION>>$CONF
read -p "ASDA (password: please leave it blank ONLY for a new subsite) = " ASDA;ASDA=${ASDA:-NOPASSWORD};echo ASDA=$ASDA>>$CONF
read -p "URL (default https://ec.europa.eu/$SITE) = " URL;URL=${URL:-"https://ec.europa.eu/$SITE"};echo URL=$URL>>$CONF
REP0=$([ $REPS = y ]&&echo reps-$SITE-reference||echo $SITE-reference);read -p "REPO (default $REP0) = " REPO;REPO=${REPO:-"$REP0"};echo REPO=$REPO>>$CONF
read -p "GITHUB REPO (https://github.com/ec-europa/$REPO.git please change the default if necessary or choose SSH) = " HTTPS;HTTPS=${HTTPS:-"https://github.com/ec-europa/$REPO.git"};echo HTTPS=$HTTPS>>$CONF
read -p "BRANCH (toolkit/upgrade: please change the default value if necessary but be careful so that the branch has the new toolkit) = " BRANCH;BRANCH=${BRANCH:-"toolkit/upgrade"};echo BRANCH=$BRANCH>>$CONF
alias drush="$DIR/$REPO/toolkit/drush -r build";echo alias $(alias drush)>>$CONF
alias phing="$DIR/$REPO/toolkit/phing";echo alias $(alias phing)>>$CONF
fi
