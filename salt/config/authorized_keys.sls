# Add from ssh_keys directory
{% for file in salt.cp.list_master(prefix='config/files/ssh_keys/') %}
{% set keyname = file.split('/')[3] %}
{{keyname}}:
  ssh_auth:
    - present
    - user: ec2-user
    - source: salt://{{ file }}
    - config: '%h/.ssh/authorized_keys'
{% endfor %}

# Add github keys
{% for user in  salt['pillar.get']('ssh-keys:present', {}) %}
github-key-{{ user }}-present:
  ssh_auth:
    - present
    - user: ec2-user
    - source: https://github.com/{{ user }}.keys
    - config: '%h/.ssh/authorized_keys'
{% endfor %}

# Ensure github keys are removed
{% for user in  salt['pillar.get']('ssh-keys:absent', {}) %}
github-key-{{ user }}-absent:
  ssh_auth:
    - absent
    - user: ec2-user
    - source: https://github.com/{{ user }}.keys
    - config: '%h/.ssh/authorized_keys'
{% endfor %}

