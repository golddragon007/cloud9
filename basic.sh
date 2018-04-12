#!/bin/sh
set -e
CLOUD=$(dirname "$(readlink -f "$0")");CONFD=$CLOUD/conf.d;CONF=$CONFD/cloud9.conf
read -p "PHP (default memory limit: 256M) = " PHP;PHP=${PHP:-256M};echo PHP=$PHP>>$CONF
read -p "HTTPD (default Apache configuration folder: /etc/httpd/conf.d) = " HTTPD;HTTPD=${HTTPD:-/etc/httpd/conf.d};echo HTTPD=$HTTPD>>$CONF
read -p "FILE (default Developer configuration file: build.develop.props) = " FILE;FILE=${FILE:-build.develop.props};echo FILE=$FILE>>$CONF
