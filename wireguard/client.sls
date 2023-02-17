## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'].items() %}
{% set own_peer = {} %}
    {% for peer in data['peers'] %}

{% if peer['name'] == grains['nodename'] %}
{% set own_peer = peer %}

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
        # rapier
        Address = {{ own_peer['address'] }} 
        PrivateKey = {{ own_peer['private_key'] }}
        SaveConfig = false
        DNS = {{ own_peer['dns'] }}

    {% for server in data['servers'] %}

        [Peer]
        # {{ server['name'] }}
        PublicKey = {{ server['public_key'] }}
        AllowedIPs = {{ server['address'] }}
        Endpoint = {{ server['endpoint'] }}
        PresharedKey = {{ server['preshared_key'] }}
        PersistentKeepalive = 30

    {% endfor %}
{% endfor %}
