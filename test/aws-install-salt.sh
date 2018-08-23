# Install salt stack minion for local usage.
# Script used by packer for testing.
# (equivalent to install-minion-Cloud9.sh for developer)

#!/bin/sh -x

# Install salt minion: https://repo.saltstack.com/#amzn
sudo yum install https://repo.saltstack.com/yum/amazon/salt-amzn-repo-latest-2.amzn1.noarch.rpm -y
sudo yum install salt-minion -y

# Set minion_id
echo "aws-test" | sudo tee /etc/salt/minion_id

# Link local sources
sudo ln -s /home/ec2-user/pillar /srv/pillar
sudo ln -s /home/ec2-user/salt /srv/salt

# Start minion
sudo service salt-minion restart

# Start default commands
sudo salt-call state.apply commands.expandFS --local
sudo salt-call state.apply --local
