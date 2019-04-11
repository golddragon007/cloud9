include:
  - config.authorized_keys
  - config.bashrc
  - config.tmux
  - config.swap
  - cloud9.runners
  - cloud9.init-js
  - cloud9.c9-js
  - docker
  - tools.drone
  - frp

/home/ec2-user/environment/.c9/salt/:
  file.directory:
    - group: ec2-user
    - user: ec2-user

{% set profile = salt['cmd.shell']('cat /tmp/profile 2>/dev/null || echo ""') %}
{{ salt['cmd.run']('rm -f /tmp/profile') }}


ProfileTime:
  cmd.run:
    - name: |
          echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/common.profile
{%- if profile != "" %}
          echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/{{ profile }}.profile
{%- endif %}
    - runas:  ec2-user

ProfileGrain:
  file:
    - serialize
    - dataset:
        salt-profile:
          - common : {{ None|strftime("%s") }}
{%- if profile != "" %}
          - {{ profile }} : {{ None|strftime("%s") }}
{%- endif %}
    - name: /etc/salt/grains
    - formatter: yaml
    - serializer_opts:
      - indent: 2
    - merge_if_exists: True
