wnameless/oracle-xe-11g:
  docker_image.present:
    - tag: latest
    - force: True

oracle11g:
  docker_container.running:
    - image: wnameless/oracle-xe-11g
    - port_bindings: {8088 : 8080, 49161: 1521}
     binds:
      - /home/ec2-user/environment/oracle_dump:/oracle_dump
    - environment:
      - ORACLE_ALLOW_REMOTE=true
    - watch_action: SIGHUP
    - detach: True
    - force: True
    
# OR http://yum.oracle.com/getting-started.html ?
instantclient-rpms:
  pkg.installed:
    - sources: 
      - instantclient_basic: salt://lamp/oracle11g/files/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
      - instantclient_basic: salt://lamp/oracle11g/files/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm

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
    - source: salt://lamp/oracle11g/files/50-oci8.ini
    - check_cmd: pecl list oci8
    - listen_in:
      - service: php-fpm