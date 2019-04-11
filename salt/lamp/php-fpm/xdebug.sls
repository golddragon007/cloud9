# Get php version in grain, or in version-default on pillar
{% set php_versions = salt['grains.get']('php-fpm:version', salt['pillar.get']('php-fpm:version-default',[ 56 ])) %}

# Override by pillar if defined (so by cli pillar value)
{% set php_versions_pillar = salt['pillar.get']('php-fpm:version') %}
{%- if php_versions_pillar != "" %}
    {% set php_versions = php_versions_pillar %}
{%- endif %}

{% for php_version in php_versions %}
xdebug{{ php_version }}-installed:
  pkg.latest:
    - name: php{{ php_version }}-php-pecl-xdebug


/etc/opt/remi/php{{ php_version }}/php.d/15-xdebug.ini:
  file.managed:
    - source: salt://lamp/php-fpm/files/15-xdebug.ini
    - template: jinja
    - listen_in:
      - service: php{{ php_version }}-php-fpm
    - require:
      - pkg: php{{ php_version }}-php-pecl-xdebug
    - context:
       php_version: {{ php_version }}
{% endfor %}