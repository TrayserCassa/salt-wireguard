## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard_external'].items() %}

wireguard_config:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.conf"
    - user: root
    - group: root
    - mode: 600
    - contents: |
        # Salt managed
        [Interface]
        Address = {{ data['address'] }} 
        PrivateKey = {{ data['private_key'] }}
        DNS = {{ data['dns'] }}

        [Peer]
        PublicKey = {{ data['public_key'] }}
        AllowedIPs = {{ data['allowed_ips'] }}
        Endpoint = {{ server['endpoint'] }}
        PersistentKeepalive = 25

wireguard_systemd_enable:
  service.running:
    - name: wg-quick@{{ interface }}
    - enable: True
    - watch:
       - file: wireguard_config

{% endfor %}
