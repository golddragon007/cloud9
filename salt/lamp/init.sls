include: 
  - lamp.httpd
  - lamp.php-fpm
  - lamp.php-fpm.*
  - lamp.mysql
  - lamp.maildev
  - lamp.phpmyadmin
  - lamp.apachesolr
  - lamp.selenium
  - lamp.matomo
  - lamp.bashrc

/home/ec2-user/environment/index.php:
  file.managed:
    - source: salt://lamp/files/index.php
    - group: ec2-user
    - user: ec2-user

/home/ec2-user/environment/phpinfo.php:
  file.managed:
    - source: salt://lamp/files/phpinfo.php
    - group: ec2-user
    - user: ec2-user
