# source 
#    - https://github.com/ec-europa/salt-ec-dc/tree/master/upsalter
#    - https://github.com/ec-europa/salt-ec-dc/tree/master/upsalter

{% set mysql_version = salt['pillar.get']('mysql:version','56') %}

# Add percona repo

{% if grains['os_family'] == 'RedHat' %}
{% set el_version = grains['osmajorrelease'][0] %}
mysql-percona-repo:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Percona official repo
    - baseurl: http://repo.percona.com/centos/$releasever/os/$basearch/
    - comments:
        - 'http://mirror.centos.org/centos/$releasever/os/$basearch/'
    - gpgcheck: 1
    - gpgkey: https://www.percona.com/downloads/RPM-GPG-KEY-percona
{% endif %}

# Server
percona-server-server:
  pkg:
    - installed
    - refresh: true
    - name: Percona-Server-server-{{ mysql_version }}
  require:
    - pkgrepo: mysql-percona-repo

# Workaround for percona init scripts
# https://github.com/saltstack/salt/issues/16153
mysqld_initd:
  file.line:
    - name: /etc/init.d/mysql
    - content: '$bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path" $other_args >/dev/null 2>&1 &'
    - match: '$bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path" $other_args >/dev/null &'
    - mode: replace
    - indent: true

# Utils
percona-toolkit:
  pkg:
    - installed
  require:
    - cmd: mysql-percona-repo

# Config
/etc/my.cnf:
  file.managed:
    - source: salt://lamp/mysql/files/my.cnf
    - require:
      - pkg: percona-server-server
    - listen_in:
      - service: mysql

# Service
mysql:
  service.running:
    - name: mysql
    - enable: True
    - require:
      - pkg: percona-server-server
      - file: mysqld_initd
      
