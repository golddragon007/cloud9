include:
  - lamp.httpd
  - docker

library/redis:
  docker_image.present:
    - tag: latest

redis:
  docker_container.running:
    - image: redis
    - port_bindings:
      - 6379:6379
    - detach: True
    - force: True
    - restart_policy: always

# Copy redis drush command
/home/ec2-user/.drush/redis:
  file.recurse:
    - source: salt://lamp/redis/files/redis
    - replace: True
    - user:  ec2-user
    - show_changes: True

# Copy redis-cli bin
/usr/local/bin/redis-cli:
  file.managed:
    - source: salt://lamp/redis/files/redis-cli.sh
    - replace: True
    - show_changes: True
    - mode: 755

rediscommander/redis-commander:
  docker_image.present:
    - tag: latest

redis-commander:
  docker_container.running:
    - image: rediscommander/redis-commander
    - port_bindings:
      - 8085:8081
    - detach: True
    - force: True
    - restart_policy: always
    - environment:
      - REDIS_HOSTS : 172.17.0.1

/etc/httpd/conf.d/redis.conf:
  file.managed:
    - source: salt://lamp/redis/files/redis.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24