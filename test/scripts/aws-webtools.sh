#!/bin/sh -e

source $HOME/.bash_profile

sudo salt-call --retcode-passthrough state.apply profiles.webtools --local

source $HOME/.bashrc

#######################
###   Check tools   ###
#######################
docker-compose --version
docker --version
drone --version

#######################
###   Check files   ###
#######################
files=(
"/mnt/docker/webtools-docker-compose.yml")

for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then echo "File '$file' not found!" ; fail=true;fi
done
if [ "$fail" == "true" ]; then
  exit 57
fi

sleep 120

#################################
###   Check services   ###
#################################
for service in "elasticsearch:9200" "cerebro:9000" ; do
  app=`echo $service |cut -d ':' -f1`
  if (($(docker ps |grep $app |wc -l) != "0")); then
    port=`echo $service |cut -d ':' -f2`
    if (( "$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$port")" != "200" )); then
      echo "Fail to connect : $app (http://127.0.0.1:$port)"; exit 76
    fi
  else
    echo "Fail to start container : $app"; exit 71
  fi
done

if (($(docker ps |grep mysql |wc -l) != "0")); then
  mysql -u root -h 127.0.0.1 -e "SHOW DATABASES;" > /dev/null
  if (("$?" == "1")); then
    echo "Fail to connect : mysql (mysql -u root -h 127.0.0.1)"; exit 76
  fi
else
  echo "Fail to start container : mysql"; exit 71
fi