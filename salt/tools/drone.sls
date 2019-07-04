drone-cli:
  cmd.run:
    - name: |
        curl -L https://github.com/drone/drone-cli/releases/download/v{{ salt['pillar.get']('drone:version','0.8.6') }}/drone_linux_amd64.tar.gz | tar zx
        install -t /usr/local/bin drone
        rm drone
    - unless: which drone && /usr/local/bin/drone --version | grep {{ salt['pillar.get']('drone:version','0.8.6') }}