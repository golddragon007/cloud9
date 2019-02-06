
# OR http://yum.oracle.com/getting-started.html ?
instantclient-rpms:
  pkg.installed:
    - sources: 
      - instantclient_basic: salt://lamp/php-fpm/files/rpms/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
      - instantclient_basic: salt://lamp/php-fpm/files/rpms/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm

fpm-devel-extensions-installed:
  pkg.latest:
    - pkgs:
      - php{{ php_version }}-devel

#install_php-oci8:
#  pecl.installed:
#    - name: oci8
#    - version: 2.0.12
#    - defaults: ""
#    - requires:
#      - pkg: php-pear

install_php-oci8:
  cmd.run: 
    - name: |
        echo "" | pecl install oci8-2.0.12 
        pecl list oci8
    - runas:  root

/etc/php.d/50-oci8.ini:
  file.managed:
    - source: salt://lamp/php-fpm/files/50-oci8.ini
    - check_cmd: pecl list oci8
    - listen_in:
      - service: php-fpm