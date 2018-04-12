#!/bin/sh
# initialise cloud9 environement for developers

# PATH
BIN=/usr/bin
BIN_LOCAL=/usr/local/bin
CLOUD=$(dirname "$(readlink -f "$0")");

# CONFIG
DRUSH_VERSION="8.1.15" # Current drush version in production
MYSQL_VERSION="56"
PHP_VERSION="56"

NOCOLOR='\e[0m'
GREEN='\e[0;32m'

# PARAMETERS    
usage="Initialise cloud9 environement for developers (bashrc, composer...)\n
Syntax : $(basename $0) [ARGS]\n
\t-?,-h, --help\t\tPrint this message\n
"

# ----- BASH RC DIRECTORY -----
cp ~/.bashrc ~/.bashrc.old
grep -q "Added by devops" ~/.bashrc
if [[ "$?" != "0" ]]; then
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

cp $CLOUD/bashrc.d/* $HOME/.bashrc.d/
echo "$GREEN[OK] Bashrc updated$NOCOLOR"

# ----- VIM CONFIG -----
cp $CLOUD/conf.default/.vimrc $HOME/

# ----- Update and install default package -----
sudo yum update -y
sudo yum install "mysql${MYSQL_VERSION}-server" php${PHP_VERSION}-pecl-xdebug phpMyAdmin -y

# ----- Enable xdebug -----
DEBUG=/etc/php-5.6.d/15-xdebug.ini;
if ! $(grep -q "^xdebug.remote_enable = 1" $DEBUG);then
	sudo sed -i /^xdebug.remote_enable/d $DEBUG;sudo sed -i "/^;xdebug.remote_enable/axdebug.remote_enable = 1" $DEBUG
fi
echo "$GREEN[OK] Default packet installed$NOCOLOR"

# ----- Devops SSH Key -----
SSH=$HOME/.ssh/authorized_keys
PUB=$CLOUD/devops.pub
grep -q devops $SSH || (echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
echo "$GREEN[OK] Devops key copied$NOCOLOR"

# ----- Git default configuration -----
read -p "GITHUB NAME (Name Surname) = " GITHUB_NAME
read -p "GITHUB EMAIL (user@domain) = " GITHUB_MAIL

git config --global user.name $GITHUB_NAME
git config --global user.email $GITHUB_MAIL
git config --global alias.st 'status'
git config --global alias.ci 'commit'
git config --global alias.br 'branch'
git config --global alias.co 'checkout'
git config --global alias.df 'diff'
git config --global alias.dc 'diff --cached'
git config --global alias.lg 'log -p'
git config --global alias.bra 'branch -a'
git config --global credential.helper 'cache --timeout=3600'

echo "$GREEN[OK] Git configuration$NOCOLOR"

# ----- Composer -----
if [ ! -f $BIN/composer ];then
	sudo curl -sS https://getcomposer.org/installer|sudo php
	sudo mv composer.phar BIN_LOCAL/composer
	sudo ln -s $BIN_LOCAL/composer $BIN/composer
fi
echo "$GREEN[OK] Composer installed$NOCOLOR"

# ----- Drone cli -----
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz|tar zx;sudo install -t /usr/local/bin drone;rm drone
echo "$GREEN[OK] Drone cli installed$NOCOLOR"

# ----- Drush 8.1.15 -----
curl https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar -L --output drush.phar
php drush.phar core-status

chmod +x drush.phar
sudo mv drush.phar $LOCAL/drush

echo "$GREEN[OK] Drush $DRUSH_VERSION installed$NOCOLOR"