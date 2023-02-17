## Installation
install_wireguard:
  pkg.installed:
    - pkgs: 
      - wireguard-tools 

{% for interface, data in pillar['wireguard'].items() %}
    {% for peer in data['peers'] %}

{% if peer['name'] == grains['nodename'] %}
wireguard_private_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.priv"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ peer['private_key'] }}"
 
wireguard_public_key:
  file.managed:
    - name: "/etc/wireguard/{{ interface }}.pub"
    - user: root
    - group: root
    - mode: 600
    - contents: 
      - "{{ peer['public_key'] }}"
{% endif %}
    {% endfor %}

    {% for server in data['servers'] %}
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
        Address = 10.8.8.3/32
        PrivateKey = QFveBgLOG4Uz6hmPFly3LpKG6zAS6EQ2eB8mw=
        SaveConfig = false


        [Peer]
        # feuer.space
        PublicKey = 25PkKLUIcZ4D1sE6PK4ePlNlOQMlVRqku5wio9uB6Fg=
        AllowedIPs = 10.8.8.1/32
        PersistentKeepalive = 30
        Endpoint = feuer.space:42445

    {% endfor %}
{% endfor %}
