npm:
  pkg.latest
  
c9:
  npm.installed:
    - require:
      - pkg: npm
    - runas: ec2-user 