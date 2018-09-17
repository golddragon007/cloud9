#!/bin/sh

source $HOME/.bash_profile

set -x

sudo salt-call state.apply profiles.lamp --local
        
# Check services
sudo service httpd status
sudo service mysql status
sudo service php-fpm status
php --version

# Check tools
docker --version
docker ps -a
docker image ls -a
drone --version
drush --version
composer --version
c9 --help

# Check docker services
for url in "phpmyadmin/" "maildev/" "solr/" "selenium/static/resource/hub.html"; do
  if (( "$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1/$url")" != "200" )); then
    echo "Fail $url"; exit 76;
  fi;
done

# Check files
files=(
"/home/ec2-user/.nvm/versions/node/$(node --version)/bin/c9"
"/home/ec2-user/environment/.c9/runners/PHP XDebug (no web server).run")

for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then echo "File '$file' not found!" ; fail=true;fi
done
if [ "$fail" == "true" ]; then
  exit 57
fi

# Test basic drupal 7 installation
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