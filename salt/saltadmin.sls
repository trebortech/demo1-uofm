# Create salt admin account

'Salt Admins sudoers file':
  file.managed:
    - name: '/etc/sudoers.d/10-saltadmins'
    - source: salt://files/saltadmins.sudoer
    - user: root
    - group: root
    - mode: 400


'Salt Admin user available':
  user.present:
    - name: saltadmin
    - fullname: SaltAdmin
    - shell: '/bin/bash'
    - password: '$1$/1hsRlz4$hFmdcqO9o6QD83mgYmE4U.'
    - groups:
      - adm
      - sudo
  ssh_auth.present:
    - user: root
    - source: salt://files/saltadmin.id_rsa.pub
    - config: '.ssh/authorized_keys'
    - require:
      - user: saltadmin