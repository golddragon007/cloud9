# Install salt stack minion for local usage.
# Script used by packer for testing.
# (equivalent to install-minion-Cloud9.sh for developer)

#!/bin/sh -x

# Start FRP srv for test
sleep 5
docker run -d --name frps -v /home/ec2-user/conf:/conf cloverzrg/frps-docker
frpsIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frps)

# Link local sources
sudo ln -s /home/ec2-user/pillar /srv/pillar
sudo ln -s /home/ec2-user/salt /srv/salt

# Create default pillar
cp /home/ec2-user/pillar/default.sls.sample /home/ec2-user/pillar/default.sls

#Add FRP (local) configuration in local pillar
sed -i -e "s/frps_host/${frpsIP}/g" /home/ec2-user/pillar/default.sls
sed -i -e 's/frps_port/7000/g' /home/ec2-user/pillar/default.sls
sed -i -e 's/frps_token/TyRnRmBrQcmRHPg6mgG9Ym7t9vL57NuZ/g' /home/ec2-user/pillar/default.sls

# Install salt minion: https://repo.saltstack.com/#amzn
sudo yum install https://repo.saltstack.com/yum/amazon/salt-amzn-repo-latest-2.amzn1.noarch.rpm -y
sudo yum install salt-minion -y

# Set minion_id
echo "aws-test" | sudo tee /etc/salt/minion_id

# Fix: https://github.com/saltstack/salt/issues/47258
sudo grep -q "service: rh_service" /etc/salt/minion || echo -e "providers:\n  service: rh_service" | sudo tee -a /etc/salt/minion

# Start minion
sudo service salt-minion restart

# Start default commands
sudo salt-call state.apply commands.expandFS --local
sudo salt-call state.apply --local

# Setup aws credentials for aws-cli usage
mkdir -p ~/.aws
rm -Rf ~/.aws/credentials

FILE="/home/ec2-user/.aws/credentials"
/bin/cat <<EOM >$FILE
[default]
aws_access_key_id=$1
aws_secret_access_key=$2
region=eu-west-1
EOM



