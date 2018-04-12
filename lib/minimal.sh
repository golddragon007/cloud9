#!/bin/sh
set -e
sudo yum -y remove '*mysql*' '*php*' '*httpd*' '*nodejs*' '*kernel*' nano '*emacs*';sudo yum -y update
