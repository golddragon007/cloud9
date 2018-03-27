#!/bin/sh
set -e;trap "echo Something went wrong... the script $0 has been aborted" ERR
DIR=$HOME/environment;CLOUD=$DIR/cloud9;CONF=$CLOUD/conf.d;KONF=$CONF/cloud9.conf;source $KONF;source $CONF/$1.conf;echo CLEAN=clone>>$1.conf
cd $DIR;[ -d $REPO ]&&rm -rf $REPO
git clone https://github.com/ec-europa/$REPO.git||(while ! git clone https://github.com/ec-europa/$REPO.git;do echo;echo Please try again\:;done);cd $REPO;git checkout -b toolkit/upgrade
