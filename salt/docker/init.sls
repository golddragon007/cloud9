{% set docker_version = salt['pillar.get']('docker:version',{}) %}

compose:
  pip.installed:
   {%- if docker_version %}
    - name: docker-compose == {{ docker_version }}
    {%- else %}
    - name: docker
    {%- endif %}

docker-service:
  service.running:
    - name: docker
    - enable: True
    - watch:
      - pip: docker
