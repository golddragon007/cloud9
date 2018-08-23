/home/ec2-user/environment/.c9/runners/:
  file.directory:
    - group: ec2-user
    - user: ec2-user

{% for file in salt.cp.list_master(prefix='cloud9/files/runners/') %}
{% set keyname = file.split('/')[3] %}
/home/ec2-user/environment/.c9/runners/{{keyname}}:
  file.managed:
    - source: salt://{{ file }}
    - replace: True
    - show_changes: True
{% endfor %}