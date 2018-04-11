<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=master" alt="build status">
</a>    

# AWS Cloud9
 
## Instructions:

Access AWS Cloud9 through THIS (Ireland) link: https://eu-west-1.console.aws.amazon.com/cloud9

Create a new environment with the name of your ECAS username and choose the EC2 t2.[small|medium|large] machine

Once created the environment open a terminal and type the following commands:

### Init environment:
```
git clone https://github.com/ec-europa/cloud9
cd cloud9
./cloud9.sh [ -h | -s | -d ]
 ```
* -h 		prints the README file
* -s 		prepares the environment and configures the basic system
* -d 		stops the Apache server for any subsite

### Manage websites:
```
./cloud9.sh [ -n | -c | -r | -e ] SUBSITE
```
* -n SUBSITE 	installs a new clean subsite using the new toolkit
* -c SUBSITE 	clones an already existing subsite using the new toolkit
* -e SUBSITE 	links the Apache server to an installed subsite
* -r SUBSITE 	deletes a previously installed subsite

### Examples:
```
./cloud9.sh -h
./cloud9.sh -c romania
./cloud9.sh -c sport
./cloud9.sh -e sport
./cloud9.sh -e romania
./cloud9.sh -d
./cloud9.sh -r romania
./cloud9.sh -n romania2
```

### Help:
 
If you still have any question please [create JIRA ticket](https://webgate.ec.europa.eu/CITnet/jira/secure/CreateIssue!default.jspa?pid=68600) or [contact devops](https://platform-ec-europa.slack.com/messages/C2NTVJA7P/).
