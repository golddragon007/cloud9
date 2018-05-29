#!/bin/sh -x
set -e
SSH=$HOME/.ssh/authorized_keys;PUB=$CONFDEFAULT/devops.pub;grep -q devops $SSH||(echo "#DevOps key:">>$SSH;cat $PUB>>$SSH)
