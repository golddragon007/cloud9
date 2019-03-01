create_swap_file:
  cmd.run:
  - name: 'dd if=/dev/zero of=/memory.swap bs=1048576 count=4 && chmod 0600 /memory.swap'
  - creates: /memory.swap
set_swap_file:
  cmd.wait:
  - name: 'mkswap /memory.swap'
  - watch:
    - cmd: create_swap_file
set_swap_file_status:
  cmd.run:
  - name: 'swapon /memory.swap'
  - unless: grep /memory.swap /proc/swaps
  - require:
    - cmd: set_swap_file
/memory.swap:
  mount.swap:
  - persist: True
  - require:
    - cmd: set_swap_file