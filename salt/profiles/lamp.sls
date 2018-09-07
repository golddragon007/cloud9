include:
  - profiles.common
  - lamp.remove
  - lamp
  - tools.composer
  - tools.drush

lampProfileTime:
  cmd.run:
    - name: echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/lamp.profile
    - runas:  ec2-user
