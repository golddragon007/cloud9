{% set php_version = salt['pillar.get']('php-fpm:version','56') %}

php{{ php_version }}-fpm:
  pkg.latest:
    - pkgs:
      - php{{ php_version }}-fpm
      - php{{ php_version }}-cli

# Install common php extensions
php-extensions-common:
  pkg.latest:
    - pkgs:
  {% for extension in  salt['pillar.get']('php-fpm:extensions-common', {}) %}
      - php{{ php_version }}-{{ extension }}
{% endfor %}

# Install php extensions for php <= 7.1
{% if php_version|int <= 71  %}
php-extensions-inf-71:
  pkg.latest:
    - pkgs:
{% for extension in  salt['pillar.get']('php-fpm:extensions-inf-71', {}) %}
      - php{{ php_version }}-{{ extension }}
{% endfor %}
{% endif %}

# Install php extensions for php >= 7.1
{% if php_version|int > 71  %}
php-extensions-sup-71:
  pkg.latest:
    - pkgs:
{% for extension in  salt['pillar.get']('php-fpm:extensions-sup-71', {}) %}
      - php{{ php_version }}-{{ extension }}
{% endfor %}
{% endif %}

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

php-fpm:
  service.running:
    - enable: True
    - require:
      - pkg: php{{ php_version }}-fpm

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