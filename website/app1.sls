# Cool site pulls from
# https://github.com/trebortech/app1-uofm.git

include:
  - nginx

{% set workingdir = "/usr/share/nginx/html/" %}


{% if pillar['version'] is defined %}
{% set env = pillar['version'] %}
{% else %}
{% set env = grains.get('version', 'base') %}
{% endif %}


####### STAGE KEYS #####################

"Set version grain":
  grains.present:
    - name: version
    - value: {{ env }}


####### PULL IN APP1 CODE ##########

"Push APP1 site code":
  file.recurse:
    - name: {{ workingdir }}
    - source: salt://APP1
    - saltenv: {{ env }}
    - makedirs: True
    - user: root
    - group: root


"Confirm NGINX service started after git deploy":
  service.running:
    - name: nginx
    - watch:
      - file: "Push APP1 site code"

