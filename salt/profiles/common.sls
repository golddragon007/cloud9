include:
  - config.authorized_keys
  - config.bashrc
  - config.tmux
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

commonProfileTime:
  cmd.run:
    - name: echo $(date +%s) >> /home/ec2-user/environment/.c9/salt/common.profile
    - runas:  ec2-user
