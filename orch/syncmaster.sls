# Orchestration file for new master server

{% set masterid = pillar.get('masterid', 'noname') %}
{% set masterip = pillar.get('masterip', 'noname') %}

"Deploy base files":
  salt.state:
    - tgt: '{{ masterid }}'
    - sls:
      - salt.masterdeploy

"Deploy master pem key file":
  salt.runner:
    - name: rsync.rsync
    - src: '/etc/salt/pki/master/master.pem'
    - dst: 'root@{{ masterip }}:/etc/salt/pki/master/master.pem'

"Deploy master pub key file":
  salt.runner:
    - name: rsync.rsync
    - src: '/etc/salt/pki/master/master.pub'
    - dst: 'root@{{ masterip }}:/etc/salt/pki/master/master.pub'

"Restart the master service":
  salt.function:
    - name: cmd.run
    - tgt: '{{ masterid }}'
    - arg:
      - 'service salt-master restart'

"Restart the minion service":
  salt.function:
    - name: cmd.run
    - tgt: '{{ masterid }}'
    - arg:
      - 'service salt-minion restart'

