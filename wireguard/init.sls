## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interfaces in pillar['wireguard'] %}
  {% for interface, data in interfaces %}

wireguard_private_key:
  file.line:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - mode: ensure
    - content: {{ interface }}
    
  {% endfor %}
{% endfor %}

