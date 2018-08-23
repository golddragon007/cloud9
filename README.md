# AWS Cloud9

[![Drone](https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=test)](https://drone.fpfis.eu/ec-europa/cloud9)

## Instructions:

Access AWS Cloud9 through this (IRELAND) link: <https://eu-west-1.console.aws.amazon.com/cloud9>

The Account alias is: digit-d1-nexteuropa-dev. The IAM user name is that assigned to you by your SCRUM master. Most probably: devs-XXX being XXX your ECAS/LDAP username.

This is the password policy: Minimum password length, 10 characters.
Require at least one uppercase letter. Require at least one lowercase letter. Require at least one number.

After successful login please create a new environment with the name of your IAM username (devs-XXX) and choose the EC2 t2.MEDIUM machine. More detail at <https://webgate.ec.europa.eu/fpfis/wikis/display/MULTISITE/AWS+Cloud9+-+Manage+Cloud9+environment>  

## Init script:

The initialization of the Cloud9 environment is MANDATORY for all users.

Once created the environment open a terminal and type the following commands:

```
git clone https://github.com/ec-europa/cloud9
cd cloud9
./install.sh
```


## Configure environemnt

Services/libraries of profiles are described at  <https://webgate.ec.europa.eu/fpfis/wikis/display/MULTISITE/AWS+Cloud9+-+Configure+Cloud9+IDE>

### Install lamp profile

```
sudo salt-call state.apply profiles.lamp
```

### Install docker profile
```
sudo salt-call state.apply profiles.docker
```
