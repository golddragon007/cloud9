# AWS Cloud9
 
 ## Instructions:

Acces AWS Cloud9 through THIS (Ireland) link: https://eu-west-1.console.aws.amazon.com/cloud9

Create a new environment with the name of your ECAS username and choose the EC2 t2.[small|medium|large] machine

Once created the environment open a terminal and type the following commands:

### Init environment:
 ```
git clone https://github.com/ec-europa/cloud9
cd cloud9
./toolkit.sh [ -h | -s | -d ]
 ```
* -h 		prints the README file
* -s 		prepares the environment and configures the basic system
* -d 		stops the Apache server for any subsite

### Manage websites:
 ```
./toolkit.sh [ -n | -c | -r | -e ] SUBSITE
 ```
* -n SUBSITE 	installs a new clean subsite
* -c SUBSITE 	clones an already existing subsite
* -e SUBSITE 	links the Apache server to an installed subsite
* -r SUBSITE 	deletes a previously installed subsite

### Examples:
 ```
./toolkit.sh -h
./toolkit.sh -c romania
./toolkit.sh -c sport
./toolkit.sh -e sport
./toolkit.sh -e romania
./toolkit.sh -d
./toolkit.sh -r romania
./toolkit.sh -n romania2
 ```

 ### Help:
 
 If you still have any question please [create JIRA ticket](https://webgate.ec.europa.eu/CITnet/jira/secure/CreateIssue!default.jspa?pid=68600) or [contact devops](https://platform-ec-europa.slack.com/messages/C2NTVJA7P/).
