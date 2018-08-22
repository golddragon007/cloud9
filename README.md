<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=master" alt="build status">
</a>    

# AWS Cloud9
 
## INSTRUCTIONS:

Access AWS Cloud9 ONLY through this link: https://eu-west-1.console.aws.amazon.com/cloud9 (IRELAND)

The Account alias is: digit-d1-nexteuropa-dev.
The IAM user name is that assigned to you by your SCRUM master. Most probably: devs-XXX being XXX your ECAS/LDAP username.

This is the password policy:
Minimum password length, 10 characters.  
Require at least one uppercase letter.
Require at least one lowercase letter.
Require at least one number.

After successful login: please create a new environment with 
the NAME of your IAM username (devs-XXX) 
and CHOOSE the EC2 t2.MEDIUM machine.

## FIRST STEP:

The initialization of the Cloud9 environment is MANDATORY for all users.

Once created the environment open a terminal and type the following commands:
```
git clone https://github.com/ec-europa/cloud9
cd cloud9
./cloud9.sh
```

## HOW TO USE IT:

In case you are a developer who wants to CLONE a subsite using TOOLKIT
then you have this option which will clone an existing subsite and all the necessary tools to debug it:
```
./cloud9.sh -c NAMEOFTHESUBSITE
```

In case you are a member of the CORE team interested in setting up a MINIMAL configuration WITHOUT Apache, PHP or MySQL
then you have this option which will install ONLY Docker, Drone and Git:
```
./cloud9.sh -m
```

In case you are a developer who only needs a basic LAMP stack (for example to use STARTERKIT)
then you have this option which will install Apache, MySQL, PHP composer, Drush, Docker, Drone and Git:
```
./cloud9.sh -p
```

## USEFUL READING:

Basically you have two options to CLONE (c) or to create a NEW (n) subsite with TOOLKIT:
```
./cloud9.sh -c NAMEOFTHESUBSITE
./cloud9.sh -n NAMEOFTHESUBSITE
```
Below you have a better description of each option as well as other available features.

```
./cloud9.sh [ -h | -m | -t | -p | -d | -a | -z ]
 ```
* -h 		prints the README file
* -m		minimal environment with Docker, Git and Drone (ideal to develop the platform)
* -t 		prepares the environment and configures the basic system for using the new toolkit (ideal to develop subsites)
* -p 		prepares a basic LAMP stack with Apache, MySQL and PHP composer
* -d 		stops the Apache server for any subsite
* -a		returns the public IP address of the virtual machine
* -z		resizes the filesystem if more space is available

```
./cloud9.sh [ -n | -c | -r | -e ] SUBSITE
```
* -n SUBSITE 	installs a new clean subsite using the new toolkit
* -c SUBSITE 	clones an already existing subsite using the new toolkit
* -e SUBSITE 	links the Apache server to an installed subsite
* -r SUBSITE 	deletes a previously installed subsite

## EXAMPLES:

```
./cloud9.sh -h
./cloud9.sh -m
./cloud9.sh -p
./cloud9.sh -t
./cloud9.sh -c romania
./cloud9.sh -c sport
./cloud9.sh -e sport
./cloud9.sh -e romania
./cloud9.sh -d
./cloud9.sh -r romania
./cloud9.sh -n romania2
```

## VIDEOS:
* [How to create a new environment](https://youtu.be/vdkMAjPbSYw)

## HELP:
 
If you still have any question please [create JIRA ticket](https://webgate.ec.europa.eu/CITnet/jira/secure/CreateIssue!default.jspa?pid=68600) or [contact devops](https://platform-ec-europa.slack.com/messages/C2NTVJA7P/).
