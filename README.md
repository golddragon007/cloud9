# cloud9

# AWS Cloud9

# Instructions:

Acces AWS Cloud9 through this link: https://eu-west-1.console.aws.amazon.com/cloud9

Create a new environment with the name of your ECAS username and choose the EC2 t2.small machine

Once created the environment open a terminal and type the following commands:

######################################################

git clone https://github.com/ec-europa/cloud9

cd cloud9

./toolkit.sh nameofthesubsite clean|clone|purge|enable

######################################################

CLEAN means a fresh clean install of a new subsite

CLONE means to download an already existing subsite

PURGE means to delete a previously downloaded subsite

ENABLE means to link the APACHE server to a specific subsite

If you still have any question please put a comment in this ticket: https://webgate.ec.europa.eu/CITnet/jira/browse/FPFISSUPP-1622
