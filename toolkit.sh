#!/bin/sh
source $HOME/$1.conf
for x in {1..5};do source $HOME/cloud9/toolkit.$x;done
