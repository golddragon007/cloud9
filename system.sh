#!/bin/sh
set -e
BASHRC=$HOME/.bashrc;grep -q "added by DevOps" $BASHRC||(echo '# added by DevOps'>>$BASHRC;echo HISTSIZE=1000000>>$BASHRC;echo HISTFILESIZE=1000000>>$BASHRC;echo 'HISTTIMEFORMAT="%F %T "'>>$BASHRC;source $BASHRC)
CLOUD=$HOME/environment/cloud9;CONF=$CLOUD/conf.d;[ -d $CONF ]||mkdir -p $CONF;KONF=$CONF/cloud9.conf
sudo sysctl -p $CLOUD/sysctl.conf 
SSH=$HOME/.ssh/authorized_keys;PUB=$CLOUD/devops.pub;grep -q devops $SSH||(echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
BIN=/usr/bin;LOCAL=/usr/local/bin;sudo yum update -y;ls $BIN/composer||(sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;sudo ln -s $LOCAL/composer $BIN/composer)
#crontab -l|grep -q growpart||(echo "* * * * * sudo growpart /dev/xvda 1;sudo resize2fs /dev/xvda1"|sudo tee -a /var/spool/cron/ec2-user;sudo chown ec2-user. /var/spool/cron/ec2-user;sudo chmod 600 /var/spool/cron/ec2-user)
