#!/bin/sh
set -e
LIB=$(dirname "$(readlink -f "$0")");CLOUD=$LIB/..;
CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
if ! $(grep -q FILE $CONF);then
read -p "FILE (default Developer configuration file: build.develop.props) = " FILE
	FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$CONF
fi
