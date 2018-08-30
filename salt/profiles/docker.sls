include:
  - profiles.common
  - docker.docker-compose
  - docker.cloud9-files

dockerProfileTime:
  cmd.run:
    - name: echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/docker.profile
    - runas:  ec2-user