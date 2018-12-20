
# Copy varnish-mock binary.
# Source code is available at tools/files/varnish-mock/varnish-mock.go
/usr/bin/varnish-mock:
  file.managed:
    - source: salt://tools/files/varnish-mock/varnish-mock
    - replace: True
    - group: root
    - user: root
    - mode: 755
