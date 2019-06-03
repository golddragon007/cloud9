#!/bin/sh -e

source $HOME/.bash_profile

sudo salt-call --retcode-passthrough state.apply profiles.lamp --local pillar='{"php-fpm":{"version":["56", "71", "72"]}, "drush":{"version":"9.5.2"}}'

##########################
###   Check services   ###
##########################
sudo service httpd status
sudo service mysql status
sudo service php72-php-fpm status

php --version

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
aliases="cloud9RestartApache cloud9RestartMysql cloud9RestartPhp cloud9RestartPhp56 cloud9RestartPhp71 cloud9RestartPhp72 cloud9RestartLamp"

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

composer create-project drupal-composer/drupal-project:7.x-dev drupal7 --no-interaction
cd /home/ec2-user/environment/drupal7/web
drush56 site-install standard --db-url=mysql://root:@127.0.0.1:3306/drupal7 --site-name=Drupal7Test --yes
echo -e "<?php\nphpinfo();" > /home/ec2-user/environment/drupal7/phpinfo.php
#### Test drupal 7 and PHP 5.6
echo -e "<FilesMatch \.php$>\nSetHandler proxy:unix:/var/opt/remi/php56/run/php-fpm/default.sock|fcgi://localhost\n</FilesMatch>"  > /home/ec2-user/environment/drupal7/.htaccess
if ( curl -s -L http://127.0.0.1:8080/drupal7/web | grep -qs "Welcome to Drupal7Test" ); then
  echo "The website Drupal7 / PHP56 is working fine";
else
  echo "Error : website Drupal7 / PHP56";
  exit 66;
fi
if ( curl -s -L http://127.0.0.1:8080/drupal7/phpinfo.php | grep -qs "PHP Version 5.6" ); then
  echo "The PHP56 version is working fine";
else
  echo "Error : PHP56 version";
  exit 566;
fi

#### Test drupal 7 and PHP 7.1
sed -i "s:php56:php71:g" /home/ec2-user/environment/drupal7/.htaccess
if ( curl -s -L http://127.0.0.1:8080/drupal7/web | grep -qs "Welcome to Drupal7Test" ); then
  echo "The website Drupal7 / PHP71 is working fine";
else
  echo "Error : website Drupal7 / PHP71";
  exit 67;
fi
if ( curl -s -L http://127.0.0.1:8080/drupal7/phpinfo.php | grep -qs "PHP Version 7.1" ); then
  echo "The PHP71 version is working fine";
else
  echo "Error : PHP71 version";
  exit 717;
fi

#######################################
###   Test basic drupal 8 install   ###
#######################################
cd /home/ec2-user/environment
composer create-project drupal-composer/drupal-project:8.x-dev drupal8 --no-interaction
cd /home/ec2-user/environment/drupal8/web
# If we use global drush, RedispatchToSiteLocal will call local drush with default php version (56). Use local drush with specified php version.
/usr/bin/php71 ../vendor/bin/drush  site-install standard --db-url=mysql://root:@127.0.0.1:3306/drupal8 --site-name=Drupal8Test --yes
echo -e "<?php\nphpinfo();" > /home/ec2-user/environment/drupal8/phpinfo.php
#### Test drupal 8 and PHP 7.1
echo "Test Drupal 8 and PHP 7.1"
echo -e "<FilesMatch \.php$>\nSetHandler proxy:unix:/var/opt/remi/php71/run/php-fpm/default.sock|fcgi://localhost\n</FilesMatch>"  > /home/ec2-user/environment/drupal8/.htaccess
if ( curl -s -L http://127.0.0.1:8080/drupal8/web | grep -qs "Welcome to Drupal8Test" ); then
  echo "The website Drupal8 / PHP71 is working fine";
else
  echo "Error : website Drupal8 / PHP71";
  exit 68;
fi
if ( curl -s -L http://127.0.0.1:8080/drupal8/phpinfo.php | grep -qs "PHP Version 7.1" ); then
  echo "The PHP71 version is working fine";
else
  echo "Error : PHP71 version";
  exit 718;
fi

#### Test drupal 8 and PHP 7.2
sed -i "s:php71:php72:g" /home/ec2-user/environment/drupal8/.htaccess
if ( curl -s -L http://127.0.0.1:8080/drupal8/web | grep -qs "Welcome to Drupal8Test" ); then
  echo "The website Drupal8 / PHP72 is working fine";
else
  echo "Error : website Drupal8 / PHP72";
  exit 69;
fi
if ( curl -s -L http://127.0.0.1:8080/drupal8/phpinfo.php | grep -qs "PHP Version 7.2" ); then
  echo "The PHP72 version is working fine";
else
  echo "Error : PHP72 version";
  exit 729;
fi