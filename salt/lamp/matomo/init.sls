include:
  - lamp.httpd
  - lamp.mysql
  - docker

create_matomo_local_dir:
  file.directory:
    - name: '/home/ec2-user/environment/conf.d/matomo'
    - group: ec2-user
    - user: ec2-user
    - makedirs : true
    - group: root
    - user: ec2-user

library/matomo:
  docker_image.present:
    - tag: latest
    - force: True

matomo:
  docker_container.running:
    - image: matomo
    - port_bindings:
      - 8084:80
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - binds:
      - /home/ec2-user/environment/conf.d/matomo/:/var/www/html/config
    - restart_policy: always

/etc/httpd/conf.d/matomo.conf:
  file.managed:
    - source: salt://lamp/matomo/files/matomo.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24


