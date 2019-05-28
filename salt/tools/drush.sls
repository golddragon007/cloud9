# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}

# Get drush version in grain, or in drush:version-default on pillar
{% set drush_version = salt['grains.get']('drush:version', salt['pillar.get']('drush:version-default', '8.1.15')) %}

# Override by pillar if defined (so by cli pillar value)
{% set drush_version_pillar = salt['pillar.get']('drush:version') %}
{%- if drush_version_pillar != "" %}
    {% set drush_version = drush_version_pillar %}
{%- endif %}

# Grab the repo, branch from pillar. Default to 8.x.
https://github.com/drush-ops/drush.git:
  git.latest:
    - rev: {{ drush_version }}
    - target: /opt/drush
    - force_reset: True

chown_drush_dir:
  file.directory:
    - name: '/opt/drush'
    - group: root
    - user: ec2-user
    - recurse:
      - user
      - group

/opt/drush:
  composer.installed:
    - composer: /usr/bin/composer
    - php: /usr/bin/php
    - onchanges:
        - git: https://github.com/drush-ops/drush.git
    - composer_home: /home/ec2-user/.composer
    - user: ec2-user

# Execute once to make sure requisites are installed
run-drush:
  cmd.run:
    - name: /usr/local/bin/drush > /opt/drush/testrun
    - require:
       - file: /usr/local/bin/drush
    - unless: test -f /opt/drush/testrun

# Drush init
{% if salt['pkg.version_cmp'](drush_version,'9') == -1 %}
init-drush:
  cmd.run:
    - name: /usr/local/bin/drush init -n
    - onlyif: test -f /usr/local/bin/drush 
    - success_retcodes: 75
{% endif %}

# Drop a symlink for users' paths
/usr/local/bin/drush:
  file.symlink:
    - target: /opt/drush/drush
    - onlyif: test -f /opt/drush/drush

# Copy base_url drush command
/home/ec2-user/.drush/base_url:
  file.recurse:
    - source: salt://tools/files/drush/base_url
    - replace: True
    - user:  ec2-user
    - show_changes: True

# Get drush registry rebuild from github
https://git.drupal.org/project/registry_rebuild.git:
  git.latest:
    - rev: 7.x-2.x
    - target: /home/ec2-user/.drush/registry_rebuild
    - force_reset: True
    
/home/ec2-user/.bashrc.d/00-devops.drush.sh:
  file.managed:
    - template: jinja
    - source: salt://tools/files/drush/00-devops.drush.sh
    - replace: True
    - show_changes: True
    - group: ec2-user
    - user: ec2-user
    - context:
      php_versions: {{ php_versions | json }}

grain-drush-version:
  file:
    - serialize
    - dataset:
        drush:
          - version: {{ drush_version }}
    - name: /etc/salt/grains
    - formatter: yaml
    - serializer_opts:
      - indent: 2
    - merge_if_exists: True
