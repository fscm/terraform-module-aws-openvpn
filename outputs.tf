#
# Outputs for the OpenVPN terraform module.
#
# Copyright 2016-2018, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

output "allowed_cidrs" {
  sensitive = false
  value     = "${var.vpn_allowed_cidrs}"
}

output "cidr" {
  sensitive = false
  value     = "${var.vpn_cidr}"
}

output "dns" {
  sensitive = false
  value     = "${var.vpn_dns}"
}

output "fqdn" {
  sensitive = false
  value     = ["${aws_route53_record.private.*.fqdn}"]
}

output "hostname" {
  sensitive = false
  value     = ["${aws_instance.openvpn.*.private_dns}"]
}

output "id" {
  sensitive = false
  value     = ["${aws_instance.openvpn.*.id}"]
}

output "ip" {
  sensitive = false
  value     = ["${aws_instance.openvpn.*.private_ip}"]
}

output "security_group" {
  sensitive = false
  value     = "${aws_security_group.openvpn.id}"
}

output "ssh_key" {
  sensitive = false
  value     = "${var.keyname}"
}
