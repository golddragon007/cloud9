Deploy jar file:
  file.managed:
    - name: /usr/sbin/cparam.jar
    - source: salt://system/files/cparam.jar
    - mode: 755
    
Deploy init script:
  file.managed:
    - name: /etc/init.d/cronp
    - source: salt://system/files/cronp
    - mode: 755

Add init script to chkconfig:
  cmd.run:
    - name: chkconfig --add /etc/init.d/cronp
    - runas:  root
    
Add init script on start:
  cmd.run:
    - name: chkconfig --level 2345 cronp on
    - runas:  root
Start cronp :
  cmd.run:
    - name: service cronp start
    - runas: root