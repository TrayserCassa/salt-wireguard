## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'] %}

wireguard_private_key:
  file.line:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - mode: ensure
    - content: {{ interface }}
    
{% endfor %}

