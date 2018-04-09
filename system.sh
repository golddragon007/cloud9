#!/bin/sh
set -e
BASHRC=$HOME/.bashrc;grep -q "added by DevOps" $BASHRC||(echo '# added by DevOps'>>$BASHRC;echo HISTSIZE=1000000>>$BASHRC;echo HISTFILESIZE=1000000>>$BASHRC;echo 'HISTTIMEFORMAT="%F %T "'>>$BASHRC;source $BASHRC)
CLOUD=$HOME/environment/cloud9;CONF=$CLOUD/conf.d;[ -d $CONF ]||mkdir -p $CONF;KONF=$CONF/cloud9.conf
sudo sysctl -p $CLOUD/sysctl.conf 
SSH=$HOME/.ssh/authorized_keys;PUB=$CLOUD/devops.pub;grep -q devops $SSH||cat $PUB>>$SSH
BIN=/usr/bin;LOCAL=/usr/local/bin;sudo yum update -y;ls $BIN/composer||(sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;sudo ln -s $LOCAL/composer $BIN/composer)
