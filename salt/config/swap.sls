#Temp swap to replace the existing
temp_swap_file:
  cmd.run:
    - name: 'fallocate -l 512M /var/tempswapfile && chmod 600 /var/tempswapfile'
    - onlyif: grep swapfile /proc/swaps
set_temp_swap_file:
  cmd.wait:
    - name: 'mkswap /var/tempswapfile'
    - onlyif: grep swapfile /proc/swaps
    - watch:
      - cmd: temp_swap_file
set_temp_swap_file_status:
  cmd.run:
    - name: 'swapon /var/tempswapfile'
    - unless: grep /var/tempswapfile /proc/swaps
    - onlyif: grep swapfile /proc/swaps
    - require:
      - cmd: set_temp_swap_file
#Create or modify swap file
disable_swap_file:
  cmd.run:
    - name: 'swapoff /var/swapfile && rm /var/swapfile'
    - onlyif: grep swapfile /proc/swaps
create_swap_file:
  cmd.run:
    - name: 'fallocate -l 2G /var/swapfile && chmod 600 /var/swapfile'
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
#Delete temp swap file
disable_tempswap_file:
  cmd.run:
    - name: 'swapoff /var/tempswapfile && rm /var/tempswapfile'
    - onlyif: grep tempswapfile /proc/swaps