#!/bin/sh
source $HOME/environment/$1.conf
for x in {1..5};do source $HOME/environment/cloud9/toolkit.$x;done
