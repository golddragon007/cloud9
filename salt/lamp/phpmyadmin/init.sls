include:
  - lamp.httpd
  - lamp.mysql
  - docker

create_pma_config_dir:
  file.directory:
    - name: '/home/ec2-user/environment/conf.d/phpmyadmin'
    - group: ec2-user
    - user: ec2-user
    - makedirs : true

/home/ec2-user/environment/conf.d/phpmyadmin/config.user.inc.php:
  file.managed:
    - source: salt://lamp/phpmyadmin/files/config.user.inc.php
    - group: root
    - user: ec2-user
    - replace : false

/home/ec2-user/environment/conf.d/phpmyadmin/config.devops.inc.php:
  file.managed:
    - source: salt://lamp/phpmyadmin/files/config.devops.inc.php
    - group: root
    - user: ec2-user

phpmyadmin/phpmyadmin:
  docker_image.present:
    - tag: latest
    - force: True

PhpMyAdmin:
  docker_container.running:
    - image: phpmyadmin/phpmyadmin
    - port_bindings:
      - 8083:80
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - binds:
      - /home/ec2-user/environment/conf.d/phpmyadmin/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php
      - /home/ec2-user/environment/conf.d/phpmyadmin/config.devops.inc.php:/etc/phpmyadmin/config.devops.inc.php
    - environment:
      - PMA_HOST : 172.17.0.1
      - PMA_PORT : 3306
      - PMA_USER : root
    - restart_policy: always

mysql-root-user:
  cmd.run:
    - name: |
        mysql -u root -e "CREATE USER 'root'@'172.0.0.0/255.0.0.0';"
        mysql -u root -e "GRANT ALL ON *.* TO 'root'@'172.0.0.0/255.0.0.0' WITH GRANT OPTION;"
    - runas:  ec2-user

/etc/httpd/conf.d/phpmyadmin.conf:
  file.managed:
    - source: salt://lamp/phpmyadmin/files/phpmyadmin.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24
