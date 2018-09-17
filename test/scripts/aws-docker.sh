#!/bin/sh

source $HOME/.bash_profile

set -x

sudo salt-call state.apply profiles.docker --local
        
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