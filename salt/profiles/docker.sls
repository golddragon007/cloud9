{{ salt['cmd.run']('touch /tmp/profile') }}
{% do salt['file.write']('/tmp/profile', "docker") %}

include:
  - profiles.common
  - docker.docker-compose
  - docker.cloud9-files
  - docker.bashrc

