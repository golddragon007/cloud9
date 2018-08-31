httpd24-tools:
  pkg:
    - latest
    
httpd24:
  pkg:
    - latest
    
httpd:
  service.running:
    - enable: True
    - require:
      - pkg: httpd24

/etc/httpd/conf.d/default-environment.conf:
  file.managed:
    - source: salt://lamp/httpd/files/default-environment.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24
    
/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://lamp/httpd/files/httpd.conf
    - listen_in:
      - service: httpd
    - require:
      - pkg: httpd24

create_httpd_log_dir:
  file.directory:
    - name: '/home/ec2-user/environment/log'
    - group: ec2-user
    - user: ec2-user

chown_httpd_log_dir:
  file.directory:
    - name: '/var/log/httpd'
    - group: root
    - user: ec2-user
    - recurse:
      - user
      - group
      
/home/ec2-user/environment/log/httpd:
  file.symlink:
    - target: /var/log/httpd