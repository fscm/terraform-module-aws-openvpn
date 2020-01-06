#
# Variables for the OpenVPN terraform module.
#
# Copyright 2016-2020, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

variable "ami_id" {
  description = "The id of the AMI to use for the instance."
  type        = "string"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address to the OpenVPN instance."
  default     = true
  type        = "string"
}

variable "domain" {
  description = "The domain name to use for the OpenVPN instance."
  type        = "string"
}

variable "extra_security_group_id" {
  description = "Extra security group to assign to the OpenVPN instance (e.g.: 'sg-3f983f98')."
  default     = ""
  type        = "string"
}

variable "instance_type" {
  description = "The type of instance to use for the OpenVPN instance."
  default     = "t2.small"
  type        = "string"
}

variable "keyname" {
  description = "The SSH key name to use for the OpenVPN instance."
  type        = "string"
}

variable "ssh_port" {
  description = "The SSH port, as defined in the original AMI from packer"
  default     = "222"
  type        = "string"
}

variable "name" {
  description = "The main name that will be used for the OpenVPN instance."
  default     = "openvpn"
  type        = "string"
}

variable "prefix" {
  description = "A prefix to prepend to the OpenVPN instance name."
  default     = ""
  type        = "string"
}

variable "private_zone_id" {
  description = "The ID of the hosted zone for the private DNS record(s)."
  default     = ""
  type        = "string"
}

variable "public_zone_id" {
  description = "The ID of the hosted zone for the public DNS record(s)."
  default     = ""
  type        = "string"
}

variable "root_volume_iops" {
  description = "The amount of provisioned IOPS (for 'io1' type only)."
  default     = 0
  type        = "string"
}

variable "root_volume_size" {
  description = "The volume size in gigabytes."
  default     = "8"
  type        = "string"
}

variable "root_volume_type" {
  description = "The volume type. Must be one of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "gp2"
  type        = "string"
}

variable "subnet_ids" {
	description = "List of Subnet IDs to launch the instance in (e.g.: ['subnet-0zfg04s2','subnet-6jm2z54q'])."
  type        = "list"
}

variable "ttl" {
  description = "The TTL (in seconds) for the DNS record(s)."
  default     = "600"
  type        = "string"
}

variable "vpc_id" {
  description = "The VPC ID for the security group(s)."
  type        = "string"
}

variable "vpn_allowed_cidrs" {
  description = "List of the subnets to which the VPN clients will be allowed access to (in CIDR notation)."
  type        = "list"
}

variable "vpn_cidr" {
  description = "The subnet for the VPN clients (in CIDR notation)."
  default     = "172.16.61.0/24"
  type        = "string"
}

variable "vpn_dns" {
  description = "List of DNS Server addresses."
  default     = []
  type        = "list"
}
