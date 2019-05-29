{% set frp_version = salt['pillar.get']('frp:version') %}

# Get frp local name from EC2 instance tag 'Name'
{% set instance_id = salt['cmd.run']('curl -s http://169.254.169.254/latest/meta-data/instance-id') %}
{% set instance_name = salt['cmd.run']('aws ec2 describe-instances --instance-ids ' + instance_id + ' --output text --query \'Reservations[].Instances[].Tags[?Key==`Name`].Value[]\'', runas='ec2-user') %}
{% set frp_name = instance_name | regex_replace('aws-cloud9-(.*)-[a-z0-9]{32}', '\\1', ignorecase=True)  %}

create_frp_folder:
 file.directory:
   - name:  /opt/frp
   - mode:  755

get_frp:
 file.managed:
   - name: /opt/frp/frp.tar.gz
   - source: https://github.com/fatedier/frp/releases/download/v{{ frp_version }}/frp_{{ frp_version }}_linux_amd64.tar.gz
   - skip_verify: True
   - require: 
     - file: create_frp_folder
   - onlyif: "test ! -d /opt/frp/{{ frp_version }}"

extract_frp:
 archive.extracted:
   - name: /opt/frp/
   - source: /opt/frp/frp.tar.gz
   - if_missing: /opt/frp/{{ frp_version }}
   - require: 
     - file: get_frp

frp_symlink:
 file.symlink:
   - name: /opt/frp/current
   - target: /opt/frp/frp_{{ frp_version }}_linux_amd64
   - onlyif: "test ! -d /opt/frp/{{ frp_version }}"

frp_generate_conf:
 file.managed:
   - name: /opt/frp/frpc.ini
   - source: salt://frp/files/frpc.ini.jinja
   - template: jinja
   - require: 
     - archive: extract_frp
   - context:
     frp_name: {{ frp_name }}

delete_frp_archive:
 file.absent:
   - name: /opt/frp/frp.tar.gz
   - require: 
     - file: get_frp
   - onlyif: "test -e /opt/frp/frp.tar.gz"
   
create_frp_user:
  user.present:
    - name: frp
    - createhome: False
    - empty_password: True
    - shell: /bin/false
    
/opt/frp:
  file.directory:
    - user: frp
    - group: frp
    - mode: 754 # some permission    
    - recurse:
      - user
      - group
    - require: 
      - archive: extract_frp
      
copy_frp_service:
  file.managed:
   - name: /etc/init.d/frpc
   - source: salt://frp/files/frpc.service
   - onlyif: "test -d /opt/frp/current"
   - mode: 755
   
enabled_frp_service:
  service.running:
    - name: frpc
    - enable: true
   
copy_logrotate_conf:
  file.managed:
   - name: /etc/logrotate.d/frp.conf
   - source: salt://frp/files/frpc.logrotate.conf
   - onlyif: "test -d /opt/frp/current"
   - mode: 644