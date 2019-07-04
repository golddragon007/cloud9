#!/usr/bin/python

import sys
import yaml
import os

stream = open("/etc/salt/grains", "r")
grains = yaml.load(stream)
php_version_grains = grains['php-fpm'][0]['version']

def checkPHPVersionExist(version, php_version_grains):
    if int(version) not in php_version_grains:
        print("PHP version %d is not installed." % int(version))
        return False
    return int(version)
    
php_version = False

if len(sys.argv) > 1:
    php_version = checkPHPVersionExist(sys.argv[1], php_version_grains)

while php_version == False:
    php_versions = ', '.join(str(x) for x in php_version_grains)
    print("Available PHP version are: " + php_versions)
    try:
        php_version_input = int(raw_input("Which PHP version by default?\n"))
        php_version = checkPHPVersionExist(php_version_input, php_version_grains)
    except ValueError:
        print("Oops!  That was no valid number.  Try again...")

# Change cli version
cmd = 'sudo /usr/sbin/alternatives --set php /usr/bin/php%d' % (php_version)
os.system(cmd)

# Change php version in httpd
cmd = "sudo sed -i 's/php[0-9]\{2\}/php%d/g' /etc/httpd/conf.d/php-fpm.conf" % (php_version)
os.system(cmd)

# Restart apache
cmd = 'sudo /etc/init.d/httpd restart > /dev/null 2>&1'
os.system(cmd)

print("Default PHP version changed to " + str(php_version))



