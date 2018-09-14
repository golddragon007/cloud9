include:
  - lamp.httpd
  - docker

selenium/standalone-chrome:
  docker_image.present:
    - tag: latest

Selenium:
  docker_container.running:
    - image: selenium/standalone-chrome
    - port_bindings:
      - 4444:4444
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
