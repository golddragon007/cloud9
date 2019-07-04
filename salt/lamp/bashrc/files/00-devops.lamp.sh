all_phpfpm_restart() {
    for php in $(chkconfig --list | grep php | cut -f1);do
      sudo service "$php" restart
    done
}

#{{ php_versions }}

alias cloud9RestartApache="sudo service httpd restart"
alias cloud9RestartMysql="sudo service mysql restart"
alias cloud9RestartPhp='all_phpfpm_restart'
{% for php_version in php_versions %}
alias cloud9RestartPhp{{ php_version }}="sudo service php{{ php_version }}-php-fpm restart"
{% endfor %}
alias cloud9RestartLamp="sudo service httpd restart;sudo service mysql restart;all_phpfpm_restart"
alias cloud9PhpSwitchVersion="phpSwitchVersion"