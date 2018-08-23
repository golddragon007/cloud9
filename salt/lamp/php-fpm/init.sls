{% set php_version = salt['pillar.get']('php:version','56') %}

fpm-stack-installed:
  pkg.installed:
    - name: php{{ php_version }}-fpm

php-fpm:
  service.running:
    - enable: True
    - require:
      - pkg: php{{ php_version }}-fpm
    
fpm-extensions-installed:
  pkg.installed:
    - pkgs:
      - php{{ php_version }}-cli
{% for extension in  salt['pillar.get']('php-fpm:extensions', {}) %}
      - php{{ php_version }}-{{ extension }}
{% endfor %}

/etc/php-fpm.d/www.conf:
  file.managed:
    - template: jinja
    - source: salt://lamp/php-fpm/files/www.conf
    - listen_in:
      - service: php-fpm
    - require:
      - pkg: php{{ php_version }}-fpm
      
/etc/php.d/00-devops.ini:
  file.managed:
    - source: salt://lamp/php-fpm/files/00-devops.ini
    - listen_in:
      - service: php-fpm
    - require:
      - pkg: php{{ php_version }}-fpm

/var/lib/php/{{ php_version }}/:
  file.directory:
    - user: ec2-user
    - group: ec2-user
    - recurse:
      - user
      - group

create_php_log_dir:
  file.directory:
    - name: '/home/ec2-user/environment/log'
    - group: ec2-user
    - user: ec2-user

chown_php_log_dir:
  file.directory:
    - name: '/var/log/php-fpm'
    - group: root
    - user: ec2-user
    - recurse:
      - user
      - group

/home/ec2-user/environment/log/php-fpm:
  file.symlink:
    - target: /var/log/php-fpm