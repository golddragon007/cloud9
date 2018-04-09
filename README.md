# cloud9

# AWS Cloud9

# Instructions:

Acces AWS Cloud9 through THIS(Ireland) link: https://eu-west-1.console.aws.amazon.com/cloud9

Create a new environment with the name of your ECAS username and choose the EC2 t2.[small|medium|large] machine

Once created the environment open a terminal and type the following commands:

######################################################

git clone https://github.com/ec-europa/cloud9

cd cloud9

./toolkit.sh [ clean|clone|purge|enable|disable|platform ] [ nameofthesubsite ]

######################################################

CLEAN means a fresh clean install of a new subsite ( f.e.: ./toolkit.sh clean romania )

CLONE means to download an already existing subsite ( f.e.: ./toolkit.sh clone romania )

PURGE means to delete a previously downloaded subsite ( f.e.: ./toolkit.sh purge romania )

ENABLE means to link the APACHE server to a specific subsite ( f.e.: ./toolkit.sh enable romania )

DISABLE means to stop the APACHE server for any subsite ( f.e.: ./toolkit.sh disable romania )

PLATFORM as a parameter means that you want to play with the platform or install your own staff ( f.e.: ./toolkit.sh platform )

If you still have any question please put a comment in this ticket: https://webgate.ec.europa.eu/CITnet/jira/browse/FPFISSUPP-1622
