expandFS:
  cmd.run:
    - name: |
        sudo growpart /dev/xvda 1
        sudo resize2fs /dev/xvda1
