#!/bin/sh -e

source $HOME/.bash_profile

sudo salt-call --retcode-passthrough state.apply profiles.docker --local

source $HOME/.bashrc

# Check tools
docker-compose --version
docker --version
drone --version
c9 --help

# Check files
files=(
"/home/ec2-user/.nvm/versions/node/$(node --version)/bin/c9"
"/home/ec2-user/environment/.c9/docker/docker-compose/docker-compose-all.yml"
"/home/ec2-user/environment/.c9/runners/PHP XDebug (no web server).run")

for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then echo "File '$file' not found!" ; fail=true;fi
done
if [ "$fail" == "true" ]; then
  exit 57
fi

#######################################
###   Test basic drupal 7 install   ###
#######################################
# this fixes the input device is not a TTY .. see https://github.com/docker/compose/issues/5696
# export COMPOSE_INTERACTIVE_NO_CLI=1

mkdir drupal
cd drupal
cp /home/ec2-user/environment/.c9/docker/docker-compose/docker-compose-all.yml ${PWD}/docker-compose.yml
mkdir build
docker-compose up -d
docker-compose exec -T web drush dl drupal-7.x
rm -Rf build
sudo mv drupal-7.x-dev build
# wait to ensure docker containers have been fully started
sleep 20
docker-compose exec -T web drush -r build site-install standard --db-url=mysql://root:@mysql:3306/drupal7 --site-name=Drupal7Test --yes
if ( curl -s -L http://127.0.0.1:8080/ | grep -qs "Welcome to Drupal7Test" ); then
  echo "The website is working fine";
else
  echo "Error";
  exit 66;
fi