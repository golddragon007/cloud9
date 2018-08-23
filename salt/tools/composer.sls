composer:
  cmd.run:
    - env:
      - HOME: '/root'
    - name: |
        wget https://getcomposer.org/installer -O /tmp/installer
        php /tmp/installer --force --install-dir=/usr/bin/ --filename=composer
    - unless: which composer