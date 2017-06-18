# Deploy files for new master server

"Deploy master configs":
  file.recurse:
    - name: '/etc/salt/master.d/'
    - source: salt://files/master.d/

"Deploy custom modules":
  file.recurse:
    - name: '/srv/modules/'
    - source: salt://custom_modules/

"Put public key into authorized file":
  ssh_auth.present:
    - user: root
    - source: salt://files/pubkeys/master.pub
    - config: '.ssh/authorized_keys'

"Pushed additional minion config files":
  file.recurse:
    - name: '/etc/salt/minion.d/'
    - source: salt://files/minion.d/
