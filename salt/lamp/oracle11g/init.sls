{% set php_version = salt['pillar.get']('php-fpm:version','56') %}

include:
  - lamp.php-fpm
  - docker

wnameless/oracle-xe-11g:
  docker_image.present:
    - tag: latest
    - force: True

oracle11g:
  docker_container.running:
    - image: wnameless/oracle-xe-11g
    - port_bindings: { 8080 : 8088 , 1521 : 49161 }
    - binds:
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
      - oracle-instantclient11.2-basic: salt://lamp/oracle11g/files/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
      - oracle-instantclient11.2-devel: salt://lamp/oracle11g/files/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm

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
    - require:
       - cmd: oci8-installed
    - listen_in:
      - service: php-fpm

oci8-installed:
  cmd.run:
    - name: pecl list oci8