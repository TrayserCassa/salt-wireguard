## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'].items() %}
{% set own_peer = {} %}
    {% for peer in data['peers'] %}

{% if peer['name'] == grains['nodename'] %}
{% if own_peer.update(peer) %}{% endif %}

wireguard_private_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ own_peer['private_key'] }}"
 
wireguard_public_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.pub"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ own_peer['public_key'] }}"

{% endif %}
    {% endfor %}


wireguard_config:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.conf"
    - user: root
    - group: root
    - mode: 600
    - contents: |
        # Salt managed
        [Interface]
        # {{ own_peer['name'] }}
        Address = {{ own_peer['address'] }} 
        PrivateKey = {{ own_peer['private_key'] }}
        SaveConfig = false
        PostUp = {{ own_peer['post_up'] }}
        PostDown = {{ own_peer['post_down'] }}
        DNS = {{ own_peer['dns'] }}
    {% for server in data['servers'] %}
        [Peer]
        # {{ server['name'] }}
        PublicKey = {{ server['public_key'] }}
        AllowedIPs = {{ server['address'] }}
        Endpoint = {{ server['endpoint'] }}
        PresharedKey = {{ server['preshared_key'] }}
        PersistentKeepalive = 25
    {% endfor %}

wireguard_systemd_enable:
  service.running:
    - name: wg-quick@{{ interface }}
    - enable: True
    - watch:
       - file: wireguard_config

{% endfor %}
