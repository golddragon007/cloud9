/home/ec2-user/environment/.c9/docker:
  file.directory:
    - user:  ec2-user
    - name:  /home/ec2-user/environment/.c9/docker

/home/ec2-user/environment/.c9/docker/docker-compose:
  file.directory:
    - user:  ec2-user
    - name:  /home/ec2-user/environment/.c9/docker/docker-compose

{% for file in salt.cp.list_master(prefix='docker/files/docker-compose/') %}
{% set keyname = file.split('/')[3] %}
/home/ec2-user/environment/.c9/docker/docker-compose/{{keyname}}:
  file.managed:
    - template: jinja
    - source: salt://{{ file }}
    - replace: True
    - show_changes: True
{% endfor %}