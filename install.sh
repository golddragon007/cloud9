# Install salt-minion and connect to cloud9 salt master

if [[ `which salt-minion` ]]; then exit 0; fi
# Salt master config
SALT_MASTER_IP="172.31.27.228"

# Install salt minion: https://repo.saltstack.com/#amzn
sudo yum install https://repo.saltstack.com/yum/amazon/salt-amzn-repo-latest-2.amzn1.noarch.rpm -y
sudo yum install salt-minion -y

# Configure master IP for salt minion
search="#master: salt"
replace="master: '$SALT_MASTER_IP'"
sudo sed -i -e "s/$search/$replace/g" /etc/salt/minion

# Fix: https://github.com/saltstack/salt/issues/47258
sudo grep -q "service: rh_service" /etc/salt/minion || echo -e "providers:\n  service: rh_service" | sudo tee -a /etc/salt/minion

# Set minion_id
AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
echo "$INSTANCE_NAME-$AWS_INSTANCE_ID" | sudo tee /etc/salt/minion_id

# Start on boot
sudo chkconfig salt-minion --level 3456 on
sudo chkconfig salt-minion --level 2 off

# Start minion
sudo service salt-minion restart

# Run init states
sudo salt-call state.apply
