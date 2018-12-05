/etc/tmux.conf:
  file.managed:
    - source: salt://config/files/tmux.conf
    - replace: True
    - show_changes: True