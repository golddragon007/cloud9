#!/bin/sh
source ./$1.conf
for x in {1..5};do source ./cloud9/toolkit.$x;done
