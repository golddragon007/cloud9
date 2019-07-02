{{ salt['cmd.run']('touch /tmp/profile') }}
{% do salt['file.write']('/tmp/profile', "webtools") %}

include:
  - profiles.common
  - tools.nodejs
  - docker.docker-compose
  - docker.bashrc
  - webtools
