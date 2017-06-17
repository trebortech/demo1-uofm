# Manage minion config for multi-master
{% if grains['kernel'] == 'Linux' %}
{% set configpath = '/etc/salt/minion.d/' %}

{% elif grains['kernel'] == 'Windows' %}
{% set configpath = 'c:\salt\conf\minion.d\' %}

{% endif %}

"Pushed additional minion config files":
  file.recurse:
    - name: {{ configpath }}
    - source: salt://files/minion.d/

"Restart minion service":
  module.run:
    - name: minionmod.restart
    - service: "salt-minion"
