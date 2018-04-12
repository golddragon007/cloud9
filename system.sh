#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;[ -d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
BASH=bashrc.conf;echo 'FILE='$BASH';grep -q $FILE $HOME/.bashrc||echo "source \$HOME/.$FILE"|tee -a $HOME/.bashrc'|sudo tee /etc/profile.d/$BASH;cp $CLOUD/$BASH $HOME/.$BASH;source $CLOUD/$BASH
SYS=sysctl.conf;sudo cp $SYS /etc/sysctl.d/99-$SYS;sudo sysctl -p $CLOUD/$SYS 
SSH=$HOME/.ssh/authorized_keys;PUB=$CLOUD/devops.pub;grep -q devops $SSH||(echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz|tar zx;sudo install -t /usr/local/bin drone;rm drone
#crontab -l|grep -q growpart||(echo "* * * * * sudo growpart /dev/xvda 1;sudo resize2fs /dev/xvda1"|sudo tee -a /var/spool/cron/ec2-user;sudo chown ec2-user. /var/spool/cron/ec2-user;sudo chmod 600 /var/spool/cron/ec2-user)
[ -f $CONF ]&&mv $CONF $CONF.OLD
read -p "GITHUB_USER (Github username) = " GITHUB_USER;GITHUB_USER=${GITHUB_USER:-NOUSER};echo GITHUB_USER=$GITHUB_USER>>$CONF
SSH=$HOME/.ssh/authorized_keys;grep -q User $SSH||(echo "#User key:">>$SSH;curl https://github.com/$GITHUB_USER.keys>>$SSH);echo "Your public keys have been downloaded from Github. Please edit $SSH if necessary.";echo
read -p "GITHUB USER (Name Surname) = " USER;USER=${USER:-NOUSER};echo USER=\"$USER\">>$CONF
read -p "GITHUB EMAIL (user@domain) = " EMAIL;EMAIL=${EMAIL:-"NOUSER@NOMAIL"};echo EMAIL=$EMAIL>>$CONF
REGION_ID=${REGION_ID:-eu-west-1};echo REGION_ID=$REGION_ID>>$CONF
ENVIRONMENT_ID=$(curl http://169.254.169.254/latest/meta-data/security-groups|awk -F'-InstanceSecurityGroup' '{print $1}'|rev|cut -d- -f1|rev);echo ENVIRONMENT_ID=$ENVIRONMENT_ID;echo ENVIRONMENT_ID=$ENVIRONMENT_ID>>$CONF
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
git config --global credential.helper 'cache --timeout=3600'
