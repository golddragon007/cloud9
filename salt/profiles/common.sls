include:
  - config.authorized_keys
  - config.bashrc
  - docker
  - tools.drone
  - cloud9.runners
  - cloud9.init-js
  - frp

/home/ec2-user/environment/.c9/salt/:
  file.directory:
    - group: ec2-user
    - user: ec2-user