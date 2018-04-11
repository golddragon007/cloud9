#!/bin/bash
# Check result of toolkit -h

# Devlops key exits ?
grep -q "devops@ec" ~/.ssh/authorized_keys

# Check git aliases
git st --help
git config --global user.name
git config --global user.email

#Check default commands
composer --version
drone --version
docker --version