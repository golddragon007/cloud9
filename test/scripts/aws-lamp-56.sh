#!/bin/sh -e

source $HOME/.bash_profile

sudo salt-call --retcode-passthrough state.apply profiles.lamp --local

##########################
###   Check services   ###
##########################
sudo service httpd status
sudo service mysql status
sudo service php56-php-fpm status


php --version
php56 --version

for php_module in "pdo_mysql" "mysqlnd" "mbstring" "opcache" "ldap" "mcrypt" "tidy"; do
  if ( php56 -m | grep -iqs "$php_module" ); then
    echo "PHP module '$php_module' is present."
  else
    echo "PHP module '$php_module' is not found."
    exit 71
  fi
done

#######################
###   Check tools   ###
#######################
docker --version
docker ps -a
docker image ls -a
drone --version
drush --version
composer --version
c9 --help
redis-cli --version

#################################
###   Check docker services   ###
#################################
for url in "phpmyadmin" "maildev" "solr" "selenium"; do
  if (( "$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1/$url/")" != "200" )); then
    echo "Fail $url"; exit 76;
  fi;
done

#########################
###   Check aliases   ###
#########################
source $HOME/.bashrc
aliases="cloud9RestartApache cloud9RestartMysql cloud9RestartPhp cloud9RestartLamp"

for alias in $aliases; do
  if [ $(alias | grep -w $alias | wc -l) != "1" ]; then
    echo "Alias $alias not found";
    exit 17
  fi
done

#######################
###   Check files   ###
#######################
files=(
"/home/ec2-user/.nvm/versions/node/$(node --version)/bin/c9"
"/home/ec2-user/environment/.c9/runners/PHP XDebug (no web server).run"
"/home/ec2-user/environment/conf.d/phpmyadmin/config.user.inc.php")

for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then echo "File '$file' not found!" ; fail=true;fi
done
if [ "$fail" == "true" ]; then
  exit 57
fi

#######################################
###   Test basic drupal 7 install   ###
#######################################
cd /home/ec2-user/environment
drush dl drupal-7.x
cd drupal-7.x-dev/
drush site-install standard --db-url=mysql://root:@127.0.0.1:3306/drupal7 --site-name=Drupal7Test --yes
if ( curl -s -L http://127.0.0.1:8080/drupal-7.x-dev | grep -qs "Welcome to Drupal7Test" ); then
  echo "The website is working fine";
else
  echo "Error";
  exit 66;
fi