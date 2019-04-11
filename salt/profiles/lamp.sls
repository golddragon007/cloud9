{{ salt['cmd.run']('touch /tmp/profile') }}
{% do salt['file.write']('/tmp/profile', "lamp") %}

include:
  - profiles.common
  - lamp.remove
  - lamp
  - tools.composer
  - tools.drush


