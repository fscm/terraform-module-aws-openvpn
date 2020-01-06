#cloud-config
#
# Cloud-Config template for the OpenVPN instance.
#
# Copyright 2016-2020, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#

fqdn: ${hostname}.${domain}
hostname: ${hostname}
manage_etc_hosts: true

write_files:
  - content: |
      #!/bin/bash
      echo "=== Setting up OpenVPN Instance ==="
      echo "  instance: ${hostname}.${domain}"
      sudo /usr/local/bin/ovpn_initpki -c ${hostname}.${domain}
      sudo /usr/local/bin/ovpn_config -u udp://${hostname}.${domain}:1194 ${openvpn_args} -E -S
      sudo chown nobody:nobody /etc/openvpn/crl.pem
      echo "=== All Done ==="
    path: /tmp/setup_openvpn.sh
    permissions: '0755'

runcmd:
  - /tmp/setup_openvpn.sh
  - rm /tmp/setup_openvpn.sh
