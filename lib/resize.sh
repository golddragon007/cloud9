#!/bin/sh -x
set -e
sudo growpart /dev/xvda 1;sudo resize2fs /dev/xvda1
