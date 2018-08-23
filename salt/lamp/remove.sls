lamp-remove:
  cmd.run:
    - name: yum -y remove '*mysql*' '*php*' '*httpd*' 'ssmtp'