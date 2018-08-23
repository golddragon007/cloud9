{% set gitUserName = salt['pillar.get']('git:username','') %}
{% set gitUserMail = salt['pillar.get']('git:mail','') %}

gitConfig:
  cmd.run:
    - name: |
        git config --global alias.st 'status'
        git config --global alias.ci 'commit'
        git config --global alias.br 'branch'
        git config --global alias.co 'checkout'
        git config --global alias.df 'diff'
        git config --global alias.dc 'diff --cached'
        git config --global alias.lg 'log -p'
        git config --global alias.bra 'branch -a'
        git config --global credential.helper 'cache --timeout=3600'
    - runas:  ec2-user

{%- if gitUserName %}
gitUserName:
  cmd.run:
    - name: git config --global user.name "{{ gitUserName }}"
    - runas:  ec2-user
{%- endif %}

{%- if gitUserMail %}
gitUserMail:
  cmd.run:
    - name: git config --global user.email "{{ gitUserMail }}"
    - runas:  ec2-user
{%- endif %}
