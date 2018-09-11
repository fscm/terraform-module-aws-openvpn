#
# Terraform module to create an OpenVPN service.
#
# Copyright 2016-2018, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

#
# OpenVPN instance.
#

resource "aws_instance" "openvpn" {
  count                       = 1
  ami                         = "${var.ami_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.keyname}"
  source_dest_check           = false
  subnet_id                   = "${element(var.subnet_ids, count.index)}"
  user_data                   = "${element(data.template_file.openvpn.*.rendered, count.index)}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn.id}","${aws_security_group.openvpn_public.id}","${var.extra_security_group_id}"]
  root_block_device {
    volume_size = "${var.root_volume_size}"
    volume_type = "${var.root_volume_type}"
    iops        = "${var.root_volume_iops}"
  }
  tags {
    Name    = "${var.prefix}${var.name}${format("%02d", count.index + 1)}"
    OpenVPN = "true"
    Service = "OpenVPN"
  }
}

data "template_file" "openvpn" {
  count    = 1
  template = "${file("${path.module}/templates/cloud-config/init.tpl")}"
  vars {
    domain       = "${var.domain}"
    hostname     = "${var.prefix}${var.name}${format("%02d", count.index + 1)}"
    openvpn_args = "-s ${var.vpn_cidr} ${length(var.vpn_dns) > 0 ? "-d -n join(',', var.vpn_dns)" : ""} ${join(" ", data.template_file.openvpn_rule.*.rendered)}"
  }
}

data "template_file" "openvpn_rule" {
  count    = "${length(var.vpn_allowed_cidrs)}"
  template = "-p 'route $${network_addr} $${network_mask}'"
  vars {
    network_addr = "${cidrhost(var.vpn_allowed_cidrs[count.index], 0)}"
    network_mask = "${cidrnetmask(var.vpn_allowed_cidrs[count.index])}"
  }
}

#
# OpenVPN DNS record(s).
#

resource "aws_route53_record" "private" {
  count   = "${var.private_zone_id != "" ? 1 : 0}"
  name    = "${var.prefix}${var.name}${format("%02d", count.index + 1)}"
  records = ["${element(aws_instance.openvpn.*.private_ip, count.index)}"]
  ttl     = "${var.ttl}"
  type    = "A"
  zone_id = "${var.private_zone_id}"
}

resource "aws_route53_record" "public" {
  count   = "${var.public_zone_id != "" && var.associate_public_ip_address ? 1 : 0}"
  name    = "${var.prefix}${var.name}${format("%02d", count.index + 1)}"
  records = ["${element(aws_instance.openvpn.*.public_ip, count.index)}"]
  ttl     = "${var.ttl}"
  type    = "A"
  zone_id = "${var.public_zone_id}"
}

#
# OpenVPN security group(s).
#

resource "aws_security_group" "openvpn" {
  name   = "${var.prefix}${var.name}"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = "${var.ssh_port}"
    to_port   = "${var.ssh_port}"
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name    = "${var.prefix}${var.name}"
    OpenVPN = "true"
    Service = "OpenVPN"
  }
}

resource "aws_security_group" "openvpn_public" {
  name   = "${var.prefix}${var.name}-public"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 1194
    to_port   = 1194
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name    = "${var.prefix}${var.name}-public"
    OpenVPN = "true"
    Service = "OpenVPN"
  }
}
