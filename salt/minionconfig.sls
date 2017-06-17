# Manage minion config for multi-master

"Pushed additional minion config files":
  file.recurse:
    - name: '/etc/salt/minion.d/'
    - source: salt://files/minion.d/

"Restart minion service":
  module.run:
    minionmod.restart:
      - name: 'salt-minion'