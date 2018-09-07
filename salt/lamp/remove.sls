lamp-remove:
  cmd.run:
    - name: |
        yum -y remove 'mysql*' 'php56.x86_64' 'ssmtp'
        yum clean all