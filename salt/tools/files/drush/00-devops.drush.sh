#############################
#  Do not edit this file.   #
#  File managed by salt.    #
#############################

# Include Drush bash customizations.
if [ -f "$HOME/.drush/drush.bashrc" ] ; then
  source /home/ec2-user/.drush/drush.bashrc
fi

# Include Drush completion.
if [ -f "$HOME/.drush/drush.complete.sh" ] ; then
  source /home/ec2-user/.drush/drush.complete.sh
fi

# Include Drush prompt customizations.
#if [ -f "$HOME/.drush/drush.prompt.sh" ] ; then
#  source /home/ec2-user/.drush/drush.prompt.sh
#fi

# https://github.com/drush-ops/drush/issues/2065#issuecomment-452549400
unset module

{% for php_version in php_versions %}
alias drush{{ php_version }}="DRUSH_PHP=/usr/bin/php{{ php_version}} /usr/bin/php{{ php_version}} /usr/local/bin/drush"
{% endfor %}