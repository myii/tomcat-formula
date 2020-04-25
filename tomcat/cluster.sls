{% from "tomcat/map.jinja" import tomcat with context %}

include:
  - tomcat.config

{#- TODO: Upon fix, this section is only working for Tomcat 7;
          The `server.xml` template needs adapting for later versions #}
{%- if tomcat.ver == 7 %}
tomcat 600_server_xml:
  file.accumulated:
    - name: 600_server_xml
    - filename: {{ tomcat.conf_dir }}/server.xml
    {% if tomcat.cluster is defined %}
    - text: {{ tomcat.cluster }}
    {% endif %}
    - require_in:
      - file: tomcat server_xml
    - unless: test "`uname`" = "Darwin"
{%- endif %}
