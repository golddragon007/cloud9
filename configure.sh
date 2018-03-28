#!/bin/sh -x
set -e
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/$1.conf
if [ ! -f $KONF ];then
read -p "SITE (default name: $1) = " SITE;SITE=${SITE:-"$1"};echo SITE=$SITE>>$KONF
read -p "REPS (y/n) = " REPS;REPS=${REPS:-n};echo REPS=$REPS>>$KONF
read -p "VERSION (2.x.x please do not leave it blank) = " VERSION;echo VERSION=$VERSION>>$KONF
read -p "ASDA (password) = " ASDA;ASDA=${ASDA:-NOPASSWORD};echo ASDA=$ASDA>>$KONF
read -p "URL (default https://ec.europa.eu/$SITE) = " URL;URL=${URL:-"https://ec.europa.eu/$SITE"};echo URL=$URL>>$KONF
REP0=$([ $REPS = y ]&&echo reps-$SITE-reference||echo $SITE-reference);read -p "REPO (default $REP0) = " REPO;REPO=${REPO:-"$REP0"};echo REPO=$REPO>>$KONF
read -p "GITHUB REPO (default https://github.com/ec-europa/$REPO.git but you can choose SSH or change the URL) = " HTTPS;HTTPS=${HTTPS:-"https://github.com/ec-europa/$REPO.git"};echo HTTPS=$HTTPS>>$KONF
alias drush="$DIR/$REPO/toolkit/drush -r build";echo alias $(alias drush)>>$KONF
alias phing="$DIR/$REPO/toolkit/phing";echo alias $(alias phing)>>$KONF
fi
