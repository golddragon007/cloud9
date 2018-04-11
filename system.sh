#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;[ -d $CONFD ]||mkdir -p $CONFD;CONF=$CONFD/cloud9.conf
BASH=bashrc.conf;echo 'FILE='$BASH';grep -q $FILE $HOME/.bashrc||echo "source \$HOME/.$FILE"|tee -a $HOME/.bashrc'|sudo tee /etc/profile.d/$BASH;cp $CLOUD/$BASH $HOME/.$BASH;source $CLOUD/$BASH
SYS=sysctl.conf;sudo cp $SYS /etc/sysctl.d/99-$SYS;sudo sysctl -p $CLOUD/$SYS 
SSH=$HOME/.ssh/authorized_keys;PUB=$CLOUD/devops.pub;grep -q devops $SSH||(echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
BIN=/usr/bin;LOCAL=/usr/local/bin;sudo yum update -y;ls $BIN/composer||(sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;sudo ln -s $LOCAL/composer $BIN/composer)
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz|tar zx;sudo install -t /usr/local/bin drone
#crontab -l|grep -q growpart||(echo "* * * * * sudo growpart /dev/xvda 1;sudo resize2fs /dev/xvda1"|sudo tee -a /var/spool/cron/ec2-user;sudo chown ec2-user. /var/spool/cron/ec2-user;sudo chmod 600 /var/spool/cron/ec2-user)
