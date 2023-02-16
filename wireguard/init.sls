## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'].items() %}

wireguard_private_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - user: root
    - group: root
    - mode: 600
    - contents: {{ interface }}
    
{% endfor %}

