lamp-remove:
  cmd.run:
    - name: |
        yum -y remove 'mysql*' 'php56*' 'ssmtp'
        yum clean all
