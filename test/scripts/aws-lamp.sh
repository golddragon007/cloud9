#!/bin/sh -x

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

