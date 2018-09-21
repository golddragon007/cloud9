#!/bin/sh

CLOUD=$(dirname "$(readlink -f "$0")");
CONFD=$CLOUD/conf.d;
CONF=$CONFD/cloud9.conf;
LIB=$CLOUD/lib;

getopts ":hazdmpxtc:n:e:r:" ACTION

case "$ACTION" in
h) cat README.md;;
c) if [ ! -f $CONF ]; then
     $LIB/system.sh
     $LIB/ip.sh
  fi
  
  $LIB/configure.sh $OPTARG
  $LIB/clone.sh $OPTARG
  $LIB/install.sh $OPTARG clone;;

n)if [ ! -f $CONF ]; then
     $LIB/system.sh
     $LIB/ip.sh
  fi
  
  $LIB/configure.sh $OPTARG;
  $LIB/install.sh $OPTARG clean;;

r)source $CONF
  source $CONFD/$OPTARG.conf
  rm -rf $DIR/$REPO 
  $CONFD/$OPTARG.conf;;
  
:) echo "The option -$OPTARG requires the name of the subsite as an argument";;
\?) echo "Invalid option: -$OPTARG";echo "Please use -h option to get help";;

esac
