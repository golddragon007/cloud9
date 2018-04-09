#!/bin/sh
set -e
CLOUD=$HOME/environment/cloud9;CONF=$CLOUD/conf.d;[ -d $CONF ]||mkdir -p $CONF;KONF=$CONF/cloud9.conf
if [ ! -f $KONF ];then
read -p "GITHUB_USER (Github username) = " GITHUB_USER;GITHUB_USER=${GITHUB_USER:-NOUSER};echo GITHUB_USER=$GITHUB_USER>>$KONF
SSH=$HOME/.ssh/authorized_keys;grep -q User $SSH||(echo "#User key:">>$SSH;curl https://github.com/$GITHUB_USER.keys>>$SSH)
read -p "GITHUB USER (Name Surname) = " USER;USER=${USER:-NOUSER};echo USER=\"$USER\">>$KONF
read -p "GITHUB EMAIL (user@domain) = " EMAIL;EMAIL=${EMAIL:-"NOUSER@NOMAIL"};echo EMAIL=$EMAIL>>$KONF
read -p "PHP (default memory limit: 256M) = " PHP;PHP=${PHP:-256M};echo PHP=$PHP>>$KONF
read -p "HTTP (default Apache configuration file: /etc/httpd/conf/httpd.conf) = " HTTP;HTTP=${HTTP:-/etc/httpd/conf/httpd.conf};echo HTTP=$HTTP>>$KONF
#read -p "FILE (default Developer configuration file: build.develop.props) = " FILE;FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$KONF
#read -p "REGION_ID (default AWS region Ireland: eu-west-1) = " REGION_ID;REGION_ID=${REGION_ID:-eu-west-1};echo REGION_ID=$REGION_ID>>$KONF
ENVIRONMENT_ID=$(curl http://169.254.169.254/latest/meta-data/security-groups|cut -d\- -f4);echo ENVIRONMENT_ID=$ENVIRONMENT_ID;echo ENVIRONMENT_ID=$ENVIRONMENT_ID>>$KONF
git config --global user.name $USER;git config --global user.email $EMAIL
git config --global alias.st 'status'
git config --global alias.ci 'commit'
git config --global alias.br 'branch'
git config --global alias.co 'checkout'
git config --global alias.df 'diff'
git config --global alias.dc 'diff --cached'
git config --global alias.lg 'log -p'
git config --global alias.bra 'branch -a'
fi
#!/bin/sh
set -e
BASHRC=$HOME/.bashrc;grep -q "added by DevOps" $BASHRC||(echo '# added by DevOps'>>$BASHRC;echo HISTSIZE=1000000>>$BASHRC;echo HISTFILESIZE=1000000>>$BASHRC;echo 'HISTTIMEFORMAT="%F %T "'>>$BASHRC;source $BASHRC)
CLOUD=$HOME/environment/cloud9;CONF=$CLOUD/conf.d;[ -d $CONF ]||mkdir -p $CONF;KONF=$CONF/cloud9.conf
sudo sysctl -p $CLOUD/sysctl.conf 
BIN=/usr/bin;LOCAL=/usr/local/bin;sudo yum update -y;ls $BIN/composer||(sudo curl -sS https://getcomposer.org/installer|sudo php;sudo mv composer.phar $LOCAL/composer;sudo ln -s $LOCAL/composer $BIN/composer)
