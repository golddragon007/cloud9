/home/ec2-user/environment/.c9/salt/set_minion_id.sh:
  file.managed:
    - source: salt://config/files/set_minion_id.sh
    - replace: True
    - show_changes: True
    - group: ec2-user
    - user: ec2-user
    - mode: 744
    - makedirs : True
  cron.present:
    - user: ec2-user
    - special: '@reboot'
    