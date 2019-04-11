# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}

include:
  - config.bashrc

{% for file in salt.cp.list_master(prefix='lamp/bashrc/files/') %}
{% set keyname = file.split('/')[3] %}
/home/ec2-user/.bashrc.d/{{keyname}}:
  file.managed:
    - template: jinja
    - source: salt://{{ file }}
    - replace: True
    - show_changes: True
    - group: ec2-user
    - user: ec2-user
    - context:
      php_versions: {{ php_versions  | json }}
{% endfor %}