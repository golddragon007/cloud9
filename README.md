<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=master" alt="build status">
</a>    

# AWS Cloud9
 
## Instructions:

Access AWS Cloud9 through THIS (Ireland) link: https://eu-west-1.console.aws.amazon.com/cloud9

Create a new environment with the name of your ECAS username and choose the EC2 t2.[small|medium|large] machine

## Init script:

The initialization of the Cloud9 environment is mandatory for all users.

Once created the environment open a terminal and type the following commands:
```
git clone https://github.com/ec-europa/cloud9
cd cloud9
```

There are four different ways to initialize your machine.
Now I am going to explain which choice might be more convenient to you:

In case you are member of the core team interested in setting up a minimal configuration WITHOUT Apache, PHP and MySQL
then you have this option which will install ONLY Docker, Drone and Git:
```
./cloud9.sh -m
```

In case you are developer who wants to use the new toolkit to create or download an existing subsite
then you need this option which will install Apache, PHP composer, MySQL, Xdebug, Selenium and other stuff:
```
./cloud9.sh -s
```

In case you are a developer who only needs a basic LAMP stack
then you have this option which will install Apache, PHP composer, MySQL, Docker, Drone and Git:
```
./cloud9.sh -p
```

The last available option is equivalent to the latter but with Xdebug and some other configuration files for completion:
```
./initCloud9.sh
```
This last script initCloud9 will:
- configure git
- add SSH devops key
- Install composer
- Install drone cli
- Install linux packages

## Advanced scripts:

Scripts to manage Cloud9 environement services and drupal website (using toolkit) are provided.
Basically you have two options to clone (c) or to create a new (n) subsite with toolkit:
```
./cloud9.sh -c NAMEOFTHESUBSITE
./cloud9.sh -n NAMEOFTHESUBSITE
```
Below you have a better description of each option as well as other available features.

### Configure environment:

```
git clone https://github.com/ec-europa/cloud9
cd cloud9
./cloud9.sh [ -h | -m | -s | -p | -d ]
 ```
* -h 		prints the README file
* -m		minimal environment with Docker, Git and Drone (ideal to develop the platform)
* -s 		prepares the environment and configures the basic system for using the new toolkit (ideal to develop subsites)
* -p 		prepares a basic LAMP stack with Apache, MySQL and PHP composer
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
./cloud9.sh -m
./cloud9.sh -p
./cloud9.sh -s
./cloud9.sh -c romania
./cloud9.sh -c sport
./cloud9.sh -e sport
./cloud9.sh -e romania
./cloud9.sh -d
./cloud9.sh -r romania
./cloud9.sh -n romania2
```

## Help:
 
If you still have any question please [create JIRA ticket](https://webgate.ec.europa.eu/CITnet/jira/secure/CreateIssue!default.jspa?pid=68600) or [contact devops](https://platform-ec-europa.slack.com/messages/C2NTVJA7P/).
