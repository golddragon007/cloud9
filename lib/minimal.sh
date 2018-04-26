#!/bin/sh
set -e
sudo yum -y remove '*mysql*' '*php*' '*httpd*' '*nodejs*' '*kernel*' nano '*emacs*' '*rpc*';sudo yum -y update
BIN=/usr/bin;LOCAL=/usr/local/bin;

if [ ! -f $BIN/drone ];then
	curl -L https://github.com/drone/drone-cli/releases/download/v0.8.5/drone_linux_amd64.tar.gz|tar zx;
	sudo install -t /usr/local/bin drone;rm drone;sudo ln -s $LOCAL/drone $BIN/drone
fi
sudo pip install docker-compose --upgrade
