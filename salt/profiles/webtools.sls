include:
  - profiles.common
  - tools.nodejs

webtoolsProfileTime:
  cmd.run:
    - name: echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/webtools.profile
    - runas:  ec2-user