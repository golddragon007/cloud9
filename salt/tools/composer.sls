# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}


composer:
  cmd.run:
    - env:
      - HOME: '/root'
    - name: |
        wget https://getcomposer.org/installer -O /tmp/installer
        php /tmp/installer --force --install-dir=/usr/bin/ --filename=composer
    - unless: which composer
/home/ec2-user/.bashrc.d/00-devops.composer.sh:
  file.managed:
    - template: jinja
    - source: salt://tools/files/composer/00-devops.composer.sh
    - replace: True
    - show_changes: True
    - group: ec2-user
    - user: ec2-user
    - context:
      php_versions: {{ php_versions | json }}