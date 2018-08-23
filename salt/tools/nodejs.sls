{% set node_version = salt['pillar.get']('nodejs:version','10') %}

nodejsInstalled:
  cmd.run:
    - name: |
        source ~/.nvm/nvm.sh
        nvm install {{ node_version }}
        nvm use {{ node_version }}
    - runas:  ec2-user