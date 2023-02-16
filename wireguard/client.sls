## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'].items() %}
  {% for peer in data['peers'] %}
wireguard_private_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - user: root
    - group: root
    - mode: 600
    - contents: {{ peer['private_key'] }}
 
 wireguard_public_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.pub"
    - user: root
    - group: root
    - mode: 600
    - contents: {{ peer['public_key'] }}
  {% endfor %}
{% endfor %}
