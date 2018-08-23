#!/bin/sh -x

sudo salt-call state.apply commands.expandFS --local
sudo salt-call state.apply --local

sudo salt-call state.apply config.bashrc --local
sudo salt-call state.apply config.git --local
sudo salt-call state.apply system.cleanup --local

sudo salt-call state.apply tools.nodejs --local

# Check 
git st || if (( "$?" == 1));then exit 1;fi
source ~/.bashrc
cdenv
node --version
