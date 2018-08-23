{% set php_version = salt['pillar.get']('php:version','56') %}

xdebug-installed:
  pkg.installed:
    - name: php{{ php_version }}-pecl-xdebug

/etc/php.d/15-xdebug.ini:
  file.managed:
    - source: salt://lamp/php-fpm/files/15-xdebug.ini
    - listen_in:
      - service: php-fpm
    - require:
      - pkg: php{{ php_version }}-pecl-xdebug