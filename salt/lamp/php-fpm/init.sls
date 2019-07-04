# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}

# Add remi repo
remi-repo-rpms:
  pkg.installed:
    - sources:
      - remi-release: http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Remove libwebp if not from epel
# fix for gd php extention https://forum.remirepo.net/viewtopic.php?id=3438
libwebp-remove:
  pkg.removed:
    - name: libwebp
    - onlyif:
      - yum list installed libwebp | (! grep -q epel)

# Install libwebp
libwebp-install:
  pkg.installed:
    - name: libwebp
    - disablerepo: amzn-main
    - enablerepo: epel
    
# Add php command
php{{ php_versions[0] }}-cmd:
  cmd.run:
    - name: |
        alternatives --install /usr/bin/php php /usr/bin/php{{ php_versions[0] }} 0
        alternatives --set php /usr/bin/php{{ php_versions[0] }}
    - require:
      - pkg: php{{ php_versions[0] }}-php-fpm

{% for php_version in php_versions %}
php{{ php_version }}-php-fpm:
  pkg.latest:
    - pkgs:
      - php{{ php_version }}-php-fpm
      - php{{ php_version }}-php-cli

#symbolik link for php 56
{% if php_version|int < 71  %}
/etc/opt/remi/php{{ php_version }}:
  file.symlink:
    - makedirs: True
    - target: /opt/remi/php{{ php_version }}/root/etc/
  
/var/opt/remi/php{{ php_version }}:
  file.symlink:
    - makedirs: True
    - target: /opt/remi/php{{ php_version }}/root/var/
{% endif %}

# Install common php extensions
php{{ php_version }}-extensions-common:
  pkg.latest:
    - pkgs:
{% for extension in  salt['pillar.get']('php-fpm:extensions-common', {}) %}
      - php{{ php_version }}-php-{{ extension }}
{% endfor %}

# Install php extensions for php <= 7.1
{% if php_version|int <= 71  %}
php{{ php_version }}-extensions-inf-71:
  pkg.latest:
    - pkgs:
{% for extension in  salt['pillar.get']('php-fpm:extensions-inf-71', {}) %}
      - php{{ php_version }}-php-{{ extension }}
{% endfor %}
{% endif %}

# Install php extensions for php >= 7.1
{% if php_version|int > 71  %}
php{{ php_version }}-extensions-sup-71:
  pkg.latest:
    - pkgs:
{% for extension in  salt['pillar.get']('php-fpm:extensions-sup-71', {}) %}
      - php{{ php_version }}-php-{{ extension }}
{% endfor %}
{% endif %}

/etc/opt/remi/php{{ php_version }}/php-fpm.d/www.conf:
  file.managed:
    - template: jinja
    - source: salt://lamp/php-fpm/files/www.conf
    - listen_in:
      - service: php{{ php_version }}-php-fpm
    - require:
      - pkg: php{{ php_version }}-php-fpm
    - context:
      php_version: {{ php_version }}
      
/etc/opt/remi/php{{ php_version }}/php.d/00-devops.ini:
  file.managed:
    - template: jinja
    - source: salt://lamp/php-fpm/files/00-devops.ini
    - listen_in:
      - service: php{{ php_version }}-php-fpm
    - require:
      - pkg: php{{ php_version }}-php-fpm
    - context:
      php_version: {{ php_version }}

/var/lib/php/{{ php_version }}/:
  file.directory:
    - user: ec2-user
    - group: ec2-user
    - recurse:
      - user
      - group

php{{ php_version }}-fpm:
  service.running:
    - name: php{{ php_version }}-php-fpm
    - enable: True
    - require:
      - pkg: php{{ php_version }}-php-fpm

# Add php command in alternatives
php{{ php_version }}-alternatives:
  cmd.run:
    - name: |
        alternatives --install /usr/bin/php php /usr/bin/php{{ php_version }} 0
    - require:
      - pkg: php{{ php_version }}-php-fpm

##############
# CONF LINKS #
##############
/home/ec2-user/environment/conf.d/php{{ php_version }}/php.d:
  file.symlink:
    - target: /etc/opt/remi/php{{ php_version }}/php.d
    - group: ec2-user
    - user: ec2-user
    - makedirs : true
    
chown_phpd{{ php_version }}_dir:
  file.directory:
    - name: /etc/opt/remi/php{{ php_version }}/php.d
    - group: root
    - user: ec2-user
    - recurse:
      - user
      - group
      
#>>>>> endfor <<<<<#
{% endfor %}

cp_switch_script:
  file.managed:
    - name: /usr/bin/phpSwitchVersion
    - source: salt://lamp/php-fpm/files/phpSwitchVersion.py
    - replace: True
    - show_changes: True
    - mode: 755
    
##############
# LOGS LINKS #
##############
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
    - makedirs: True
    - target: /var/log/php-fpm
    - group: ec2-user
    - user: ec2-user

#############################
# Set php versions in grain #
#############################

grain-php-version:
  file:
    - serialize
    - dataset:
        php-fpm:
          - version:
          {% for php_version in php_versions %}
            - {{ php_version }}
          {% endfor %}
    - name: /etc/salt/grains
    - formatter: yaml
    - serializer_opts:
      - indent: 2
    - merge_if_exists: True