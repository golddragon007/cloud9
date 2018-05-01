#!/bin/sh -x
set -e
sudo yum -y remove '*mysql*' '*php*' '*httpd*' '*nodejs*' kernel-tools kernel-headers nano '*emacs*' '*rpc*';sudo yum -y update
BIN=/usr/bin;LOCAL=/usr/local/bin;
	TOOL=drone;
	if [ ! -f $BIN/$TOOL ];then
		curl -L https://github.com/drone/drone-cli/releases/download/v0.8.5/drone_linux_amd64.tar.gz|tar zx;
		sudo install -t $LOCAL $TOOL;rm $TOOL;
		sudo ln -s $LOCAL/$TOOL $BIN/$TOOL;$TOOL --version
	fi
	TOOL=docker-compose;
	if [ ! -f $BIN/$TOOL ];then
		COMPOSE=1.21.1
		URL="https://github.com/docker/compose/releases/download/$COMPOSE/$TOOL-$(uname -s)-$(uname -m)"
		sudo curl -L $URL -o $LOCAL/$TOOL;sudo chmod +x $LOCAL/$TOOL
		sudo ln -s $LOCAL/$TOOL $BIN/$TOOL;$TOOL --version
	fi