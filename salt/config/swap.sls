disable_swap_file:
  cmd.run:
    - name: 'swapoff /var/swapfile && rm /var/swapfile'
    - onlyif: grep swapfile /proc/swaps
create_swap_file:
  cmd.run:
    - name: 'fallocate -l 4G /var/swapfile'
set_swap_file:
  cmd.wait:
    - name: 'mkswap /var/swapfile'
    - watch:
      - cmd: create_swap_file
set_swap_file_status:
  cmd.run:
    - name: 'swapon /var/swapfile'
    - unless: grep /var/swapfile /proc/swaps
    - require:
      - cmd: set_swap_file
/var/swapfile:
  mount.swap:
    - persist: True
    - require:
      - cmd: set_swap_file