bashrc.d:
  file.blockreplace:
    - name: /home/ec2-user/.bashrc
    - source: salt://config/files/bashrc.append
    - marker_start: "# Added by devops -DO-NOT-EDIT-"
    - marker_end: "# END # Added by devops --"
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
    
/home/ec2-user/.bashrc.d/:
  file.directory:
    - group: ec2-user
    - user: ec2-user
  

{% for file in salt.cp.list_master(prefix='config/files/bashrc.d/') %}
{% set keyname = file.split('/')[3] %}
/home/ec2-user/.bashrc.d/{{keyname}}:
  file.managed:
    - source: salt://{{ file }}
    - replace: True
    - show_changes: True
{% endfor %}

