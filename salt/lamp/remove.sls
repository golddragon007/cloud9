lamp-remove:
  cmd.run:
    - name: |
       yum -y remove 'mysql*' 'php*' 'ssmtp'
       yum clean all

#refresh_salt_pkg:
#  pkg.uptodate:
#    - refresh: true

# Call pkg to 'refresh' salt pkg cache
htop-remove:
  pkg.removed:
    - name: htop

htop-install:
  pkg.installed:
    - name: htop