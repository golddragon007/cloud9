include:
  - lamp.httpd
  - docker

selenium/standalone-chrome-debug:
  docker_image.present:
    - tag: latest

selenium:
  docker_container.running:
    - image: selenium/standalone-chrome-debug
    - port_bindings:
      - 4444:4444
      - 5900:5900
    - binds:
      - /dev/shm:/dev/shm
    - environment:
      - VNC_NO_PASSWORD=1
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - restart_policy: always
      
dougw/novnc:
  docker_image.present:
    - tag: latest

novnc:
  docker_container.running:
    - image: dougw/novnc
    - port_bindings:
      - 8081:8081
    - environment:
      - REMOTE_HOST = {{ grains['ip_interfaces']['eth0'][0] }}
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - restart_policy: always

/etc/httpd/conf.d/selenium.conf:
  file.managed:
    - source: salt://lamp/selenium/files/selenium.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24
