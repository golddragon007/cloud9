#!/bin/sh
# initialise cloud9 environement for developers

# PATH
BIN=/usr/bin
BIN_LOCAL=/usr/local/bin
CLOUD_DIR=$(dirname "$(readlink -f "$0")");

# CONFIG
DRUSH_VERSION="8.1.15" # Current drush version in production
MYSQL_VERSION="55"
PHP_VERSION="56"
PACKETS_LAMP_="mysql${MYSQL_VERSION} php${PHP_VERSION} php${PHP_VERSION}-pecl-xdebug phpMyAdmin"
PACKETS_DEFAULT="htop locate"

NOCOLOR='\e[0m'
GREEN='\e[0;32m'

# PARAMETERS    
usage="Initialise cloud9 environement for developers (bashrc, composer...)\n
Syntax : $(basename $0) [ARGS]\n
\t-?,-h, --help\t\tPrint this message\n
"
echo "Start devops init..."
# ----- Update and install default package -----
sudo yum update -y
sudo yum install $PACKETS_DEFAULT -y
sudo yum install $PACKETS_LAMP_ -y
echo -ne "$GREEN[OK] Default packet installed$NOCOLOR\n"

# ----- BASH RC DIRECTORY -----
grep -q "Added by devops" ~/.bashrc
if [[ "$?" != "0" ]]; then
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

cp $CLOUD_DIR/bashrc.d/* $HOME/.bashrc.d/
echo -ne "$GREEN[OK] Bashrc updated$NOCOLOR\n"

# ----- VIM CONFIG -----
grep -q "Added by devops" ~/.vimrc
if [[ "$?" != "0" ]]; then
  cp ~/.vimrc ~/.vimrc.old
cat >> $HOME/.vimrc << EOL

# Added by devops
if filereadable(glob("~/.vimrc.devops"))
    source ~/.vimrc.devops
endif
EOL
fi
cp $CLOUD_DIR/conf.default/.vimrc.devops $HOME/
echo -ne "$GREEN[OK] Vim configuration copied$NOCOLOR\n"

# ----- Enable xdebug -----
DEBUG=/etc/php-5.6.d/15-xdebug.ini;
if ! $(grep -q "^xdebug.remote_enable = 1" $DEBUG);then
	sudo sed -i /^xdebug.remote_enable/d $DEBUG;sudo sed -i "/^;xdebug.remote_enable/axdebug.remote_enable = 1" $DEBUG
fi
echo -ne "$GREEN[OK] Default packet installed$NOCOLOR\n"

# ----- Devops SSH Key -----
SSH=$HOME/.ssh/authorized_keys
PUB=$CLOUD_DIR/devops.pub
grep -q devops $SSH || (echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
echo -ne "$GREEN[OK] Devops key copied$NOCOLOR\n"

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

echo -ne "$GREEN[OK] Git configuration$NOCOLOR\n"

# ----- Composer -----
if [ ! -f $BIN/composer ];then
	sudo curl -sS https://getcomposer.org/installer|sudo php
	sudo mv composer.phar $BIN_LOCAL/composer
	sudo ln -s $BIN_LOCAL/composer $BIN/composer
fi
echo -ne "$GREEN[OK] Composer installed$NOCOLOR\n"

# ----- Drone cli -----
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz|tar zx;sudo install -t /usr/local/bin drone;rm drone
echo -ne "$GREEN[OK] Drone cli installed$NOCOLOR\n"

# ----- Drush 8.1.15 -----
curl https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar -L --output drush.phar

chmod +x drush.phar
sudo mv drush.phar $BIN_LOCAL/drush

echo -ne "$GREEN[OK] Drush $DRUSH_VERSION installed$NOCOLOR\n"

echo "Init done."