#!/bin/sh
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;[ -d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
# ----- BASH RC DIRECTORY -----
grep -q "Added by devops" ~/.bashrc && VAL=$?
if [[ "$VAL" != "0" ]]; then
  cp ~/.bashrc ~/.bashrc.old
  mkdir -p $HOME/.bashrc.d
cat >> $HOME/.bashrc << EOL

# Added by devops
if [ -d ~/.bashrc.d ]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -r \$i ]; then
      . \$i
    fi
  done
  unset i
fi
EOL
fi
cp $CLOUD/conf.default/bashrc.d/* $HOME/.bashrc.d/;source $HOME/.bashrc
set +e;SYS=sysctl.conf;sudo cp $CONFDEFAULT/$SYS /etc/sysctl.d/99-$SYS;sudo sysctl -p $CONFDEFAULT/$SYS;set -e
SSH=$HOME/.ssh/authorized_keys;PUB=$CONFDEFAULT/devops.pub;grep -q devops $SSH||(echo "#DevOps key:">>$SSH;cat $PUB>>$SSH);ssh -V
echo "$LIB/ip.sh"|sudo tee -a /etc/rc.local
[ -f $CONF ]&&mv $CONF $CONF.OLD
read -p "GITHUB_USER (Github username) = " GITHUB_USER;GITHUB_USER=${GITHUB_USER:-NOUSER};
	echo GITHUB_USER=$GITHUB_USER>>$CONF
URL=https://github.com/$GITHUB_USER.keys;
	SSH=$HOME/.ssh/authorized_keys;grep -q User $SSH||(echo "#User key:">>$SSH;curl $URL>>$SSH);
	echo "Your public keys have been downloaded from Github. Please edit $SSH if necessary.";echo
read -p "GITHUB USER (Name Surname) = " USER;USER=${USER:-NOUSER};echo USER=\"$USER\">>$CONF
read -p "GITHUB EMAIL (user@domain) = " EMAIL;EMAIL=${EMAIL:-"NOUSER@NOMAIL"};echo EMAIL=$EMAIL>>$CONF
REGION_ID=${REGION_ID:-eu-west-1};echo REGION_ID=$REGION_ID>>$CONF
URL=http://169.254.169.254/latest/meta-data/security-groups;
	ENVIRONMENT_ID=$(curl $URL|awk -F'-InstanceSecurityGroup' '{print $1}'|rev|cut -d- -f1|rev);
	echo ENVIRONMENT_ID=$ENVIRONMENT_ID;echo ENVIRONMENT_ID=$ENVIRONMENT_ID>>$CONF
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
git --version
