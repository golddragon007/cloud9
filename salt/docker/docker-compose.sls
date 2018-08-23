{% set compose_version = salt['pillar.get']('docker.docker-compose:version',{}) %}

docker-compose-install:
  pip.installed:
    {%- if compose_version %}
    - name: docker-compose == {{ compose_version }}
    {%- else %}
    - name: docker-compose
{%- endif %}