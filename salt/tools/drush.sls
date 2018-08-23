# Grab the repo, branch from pillar. Default to 8.x.
https://github.com/drush-ops/drush.git:
  git.latest:
    - rev: {{ salt['pillar.get']('drush:version', '8.x') }}
    - target: /opt/drush
    - force_reset: True

/opt/drush:
  composer.installed:
    - composer: /usr/bin/composer
    - php: /usr/bin/php
    - onchanges:
        - git: https://github.com/drush-ops/drush.git


# Execute once to make sure requisites are installed
run-drush:
  cmd.run:
    - name: /usr/local/bin/drush > /opt/drush/testrun
    - require:
       - file: /usr/local/bin/drush
    - unless: test -f /opt/drush/testrun

# Drop a symlink for users' paths
/usr/local/bin/drush:
  file.symlink:
    - target: /opt/drush/drush
    - onlyif: test -f /opt/drush/drush

# Copy base_url drush command
/home/ec2-user/.drush/base_url:
  file.recurse:
    - source: salt://tools/files/drush/base_url
    - replace: True
    - user:  ec2-user
    - show_changes: True
    
# Get drush registry rebuild command
install_registry_rebuild:
  cmd.run:
    - name: /opt/drush/drush pm-download -y registry_rebuild-7.x
    - cwd: /
    - onlyif: test -f /opt/drush/drush
    - runas:  ec2-user
    
