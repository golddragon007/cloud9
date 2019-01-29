#!/bin/sh -e

source $HOME/.bash_profile

set -x

sudo salt-call --retcode-passthrough state.apply commands.expandFS --local

sudo salt-call --retcode-passthrough state.apply --local

sudo salt-call --retcode-passthrough state.apply config.bashrc --local

sudo salt-call --retcode-passthrough state.apply config.git --local

sudo salt-call --retcode-passthrough state.apply system.cleanup --local

sudo salt-call --retcode-passthrough state.apply tools.nodejs --local

sudo salt-call --retcode-passthrough state.apply frp --local

#################################
###   Test git & bash alias   ###
#################################
git st || if (( "$?" == 1));then exit 1;fi
source ~/.bashrc
cdenv
node --version

######################################
###   Test Java autoshutdown app   ###
######################################

# Ensure service is started at c9 boot
if ! sudo /etc/init.d/cronp status; then echo "Cronp status failed, exit..." ; exit 22; fi
# Test replacement at service start
sudo /etc/init.d/cronp stop
if ! egrep "@automaticShutdown" /home/ec2-user/environment/.c9/project.settings; then
  sed -i '0,/{/s//{\n    "instance": { "@automaticShutdown": "66" }/' /home/ec2-user/environment/.c9/project.settings
else
  sed -i -e 's/"@automaticShutdown".*:.*".*"/"@automaticShutdown":"66"/g' /home/ec2-user/environment/.c9/project.settings
fi
sudo /etc/init.d/cronp start
sleep 2
if ! egrep '@automaticShutdown".*:.*"30"' /home/ec2-user/environment/.c9/project.settings; then echo "Change on project.settings fail, exit..." ; exit 23; fi
# Test replacement on live
sed -i -e 's/"@automaticShutdown".*:.*".*"/"@automaticShutdown":"66"/g' /home/ec2-user/environment/.c9/project.settings
sleep 2
if ! egrep '@automaticShutdown".*:.*"30"' /home/ec2-user/environment/.c9/project.settings; then echo "Change on project.settings fail, exit..." ; exit 24; fi
# Test java don't fail after second replacement
sed -i -e 's/"@automaticShutdown".*:.*".*"/"@automaticShutdown":"66"/g' /home/ec2-user/environment/.c9/project.settings
sleep 2
if ! egrep '@automaticShutdown".*:.*"30"' /home/ec2-user/environment/.c9/project.settings; then echo "Change on project.settings fail, exit..." ; exit 25; fi
if ! sudo /etc/init.d/cronp status; then echo "Cronp status failed, exit..." ; exit 26; fi

