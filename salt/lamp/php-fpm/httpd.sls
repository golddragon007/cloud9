/etc/httpd/conf.d/php-fpm.conf:
  file.managed:
    - source: salt://lamp/php-fpm/files/php-fpm.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24