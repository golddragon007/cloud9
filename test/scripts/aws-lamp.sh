#!/bin/sh -x

source $HOME/.bash_profile

sudo salt-call state.apply profiles.lamp --local
        
# Check services
sudo service httpd status
sudo service mysql status
sudo service php-fpm status

php --version

# Check docker services
for url in phpmyadmin maildev solr; do
  if (( "$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1/$url/")" != "200" )); then exit 1; fi
done

# Check tools
docker --version
drone --version
drush --version
composer --version
c9 --help

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