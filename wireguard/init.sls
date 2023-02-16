## Installation
wireguard.deps.installed:
  pkg.installed:
    - pkgs: wireguard


## Interface Setup
# {% for interface, interface_config in config.interfaces | dictsort %}
#   {% set is_interface_disabled = interface_config.disabled | default(False) %}

# /etc/wireguard/{{ interface }}.conf:
#   file.managed:
#     - source: salt://wireguard/files/wireguard.conf
#     - template: jinja
#     - context:
#         config: {{ interface_config | json }}
#     - mode: 660

# This refreshes systemd's unit file caches
# wireguard.interface.{{ interface }}.systemctl_reload:
#   module.run:
#     - name: service.systemctl_reload
#     - onchanges:
#       - wireguard.install
#       - /etc/wireguard/{{ interface }}.conf

# This brings up or tears down the interface
# wireguard.interface.{{ interface }}.service:
#   {% if is_interface_disabled %}
#   service.dead:
#     - name: wg-quick@{{ interface }}
#     - enable: False
#   {% else %}
#   service.running:
#     - name: wg-quick@{{ interface }}
#     - enable: True
#     - watch:
#       - wireguard.install
#       - /etc/wireguard/{{ interface }}.conf
#       - wireguard.interface.{{ interface }}.systemctl_reload
#   {% endif %}

# This refreshes the peer's endpoint periodically.
#   {% for peer, peer_config in interface_config.peers | dictsort %}
#     {% if peer_config.refresh_endpoint | default(False) %}
# {{ timer(
#   disabled=is_interface_disabled,
#   service_name="wireguard-" + interface + "-refresh-peer-" + peer,
#   exec_start="/usr/bin/wg set " + interface + " peer " + peer_config.conf.PublicKey + " allowed-ips " + peer_config.conf.AllowedIPs + " endpoint " + peer_config.conf.Endpoint,
#   period='*:0/1'
# ) }}
#     {% endif %}
#   {% endfor %}
# {% endfor %}
