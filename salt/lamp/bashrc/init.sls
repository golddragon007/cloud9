include:
  - config.bashrc

{% for file in salt.cp.list_master(prefix='lamp/bashrc/files/') %}
{% set keyname = file.split('/')[3] %}
/home/ec2-user/.bashrc.d/{{keyname}}:
  file.managed:
    - source: salt://{{ file }}
    - replace: True
    - show_changes: True
{% endfor %}