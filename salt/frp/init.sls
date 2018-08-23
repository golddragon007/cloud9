/root/frpc.sh:
  file.managed:
    - source: salt://frp/files/frpc.sh.jinja
    - template: jinja

install_frp:
  cmd.run:
    - name: sh /root/frpc.sh
    - unless: ls -l /opt/frp/salt['pillar.get']('frp:version')
