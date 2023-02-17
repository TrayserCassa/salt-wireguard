## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% set own_server = {} %}
{% for interface, data in pillar['wireguard'].items() %}
    {% for server in data['servers'] %}
        {% if server['name'] == grains['nodename'] %}
            {% if own_server.update(server) %}{% endif %}
wireguard_private_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ own_server['private_key'] }}"
 
wireguard_public_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.pub"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ own_server['public_key'] }}"

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
        # {{ own_server['name'] }}
        Address = {{ own_server['address'] }} 
        PrivateKey = {{ own_server['private_key'] }}
        SaveConfig = false
        PostUp = {{ own_server['post_up'] }}
        PostDown = {{ own_server['post_down'] }}

    {% for peer in data['peers'] %}
        [Peer]
        # {{ peer['name'] }}
        PublicKey = {{ peer['public_key'] }}
        AllowedIPs = {{ peer['address'] }}
        PresharedKey = {{ own_server['preshared_key'] }}
    {% endfor %}

    {% for server in data['servers'] %}
        {%- if server['name'] == own_server['name'] %}
        {%- continue %}
        {%- endif %}
        # {{ server['name'] }}
        PublicKey = {{ server['public_key'] }}
        AllowedIPs = {{ server['address'] }}
        PresharedKey = {{ own_server['preshared_key'] }}
    {% endfor %}
{% endfor %}
