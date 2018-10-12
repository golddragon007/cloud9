/tmp/setupGrains.py:
  file.managed:
    - source: salt://commands/files/setupGrains.py
    - template: jinja

setup_grains:
  cmd.run:
    - name: |
        /usr/bin/python27 /tmp/setupGrains.py
        salt-call saltutil.refresh_grains
    - runas:  root