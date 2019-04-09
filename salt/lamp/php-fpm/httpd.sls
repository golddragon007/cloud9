# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}

/etc/httpd/conf.d/php-fpm.conf:
  file.managed:
    - template: jinja
    - source: salt://lamp/php-fpm/files/php-fpm.conf
    - listen_in:
      - service: httpd
    - context:
      php_version: {{ php_versions[0] }}
    - require:
      - pkg: httpd24