include:
  - lamp.httpd
  - docker

djfarrelly/maildev:
  docker_image.present

MailDev:
  docker_container.running:
    - image: djfarrelly/maildev
    - port_bindings: {80 : 8081, 25: 1025}
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - restart_policy: always


/etc/httpd/conf.d/maildev.conf:
  file.managed:
    - source: salt://lamp/maildev/files/maildev.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24

ssmtp:
  pkg:
    - installed

/etc/ssmtp/ssmtp.conf:
  file.managed:
    - source: salt://lamp/maildev/files/ssmtp.conf
    - require:
      - pkg: ssmtp