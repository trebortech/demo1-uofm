# Manage additional minion config files


{% if grains['kernel'] == 'Linux' %}
    {% set configpath = '/etc/salt/minion.d/' %}
    {% set defaultconfig = '/etc/salt/minion' %}
{% elif grains['kernel'] == 'Windows' %}
    {% set configpath = 'c:\\salt\\conf\\minion.d\\' %}
    {% set defaultconfig = 'c:\\salt\\conf\\minion' %}
{% endif %}



"Pushed additional minion config files":
  file.recurse:
    - name: {{ configpath }}
    - source: salt://files/minion.d/

"Remove current master":
  file.replace:
    - name: '{{ defaultconfig }}'
    - pattern: 'master: .*$'
    - repl: '#master:'
    - backup: False

"Sync all custom modules":
  module.run:
    - name: saltutil.sync_modules

"Restart minion service":
  module.run:
    - name: minionmod.restart
    - service: "salt-minion"
    - require:
      - module: "Sync all custom modules"
