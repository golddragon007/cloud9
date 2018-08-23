/home/ec2-user/environment/.c9/init/:
  file.directory:
    - group: ec2-user
    - user: ec2-user

/home/ec2-user/environment/.c9/init/init.js:
  file.managed:
    - source: salt://cloud9/files/init.js
    - replace: True
    - show_changes: True