include:
  - lamp.httpd
  - lamp.mysql
  - docker

phpmyadmin/phpmyadmin:
  docker_image.present:
    - tag: latest

PhpMyAdmin:
  docker_container.running:
    - image: phpmyadmin/phpmyadmin
    - port_bindings:
      - 8083:80
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - environment:
      - PMA_HOST : 172.17.0.1
      - PMA_PORT : 3306
      - PMA_USER : root
    - restart_policy: always
      
mysql-root-user:
  cmd.run:
    - name: |
        mysql -u root -e "CREATE USER 'root'@'172.0.0.0/255.0.0.0';"
        mysql -u root -e "GRANT ALL ON *.* TO 'root'@'172.0.0.0/255.0.0.0';"
    - runas:  ec2-user

/etc/httpd/conf.d/phpmyadmin.conf:
  file.managed:
    - source: salt://lamp/phpmyadmin/files/phpmyadmin.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24
