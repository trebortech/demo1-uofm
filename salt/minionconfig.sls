# Manage additional minion config files


{% if grains['kernel'] == 'Linux' %}
    {% set configpath = '/etc/salt/minion.d/' %}
{% elif grains['kernel'] == 'Windows' %}
    {% set configpath = 'c:\\salt\\conf\\minion.d\\' %}
{% endif %}



"Pushed additional minion config files":
  file.recurse:
    - name: {{ configpath }}
    - source: salt://files/minion.d/

"Sync all custom modules":
  module.run:
    - name: saltutil.sync_modules

"Restart minion service":
  module.run:
    - name: minionmod.restart
    - service: "salt-minion"
    - require:
      - module: "Sync all custom modules"
