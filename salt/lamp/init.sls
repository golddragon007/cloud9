include: 
  - lamp.httpd
  - lamp.php-fpm
  - lamp.php-fpm.*
  - lamp.mysql
  - lamp.maildev
  - lamp.phpmyadmin
  - lamp.apachesolr
  - lamp.selenium
  - lamp.bashrc
  - lamp.redis

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
