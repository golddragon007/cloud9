include:
  - lamp.httpd
  - docker

fpfis/solr5:
  docker_image.present

ApacheSolr:
  docker_container.running:
    - image: fpfis/solr5
    - watch_action: SIGHUP
    - detach: True
    - force: True
    - port_bindings:
      - 8082:8983
    - restart_policy: always

/etc/httpd/conf.d/apachesolr.conf:
  file.managed:
    - source: salt://lamp/apachesolr/files/apachesolr.conf
    - listen_in:
      - service: httpd
    - require:
      - httpd24
