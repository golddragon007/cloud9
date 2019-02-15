{% set php_version = salt['pillar.get']('php-fpm:version','56') %}

{% if php_version|int <= 71 %}
    {% set php_xdebug = 'php' + php_version|string + '-pecl-xdebug' %}
{% elif php_version|int > 71 %}
    {% set php_xdebug = 'php' + php_version|string + '-php-pecl-xdebug' %}
# Add remi repo => needed for php-pecl-xdebug extension
remi-repo-rpms:
  pkg.installed:
    - sources:
      - remi-release: http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
{% endif %}

xdebug-installed:
  pkg.latest:
    - name: {{ php_xdebug }}


/etc/php.d/15-xdebug.ini:
  file.managed:
    - source: salt://lamp/php-fpm/files/15-xdebug.ini
    - template: jinja
    - listen_in:
      - service: php-fpm
    - require:
      - pkg: {{ php_xdebug }}