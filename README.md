# OpenVPN Terraform Module

A terraform module to create and manage an OpenVPN service on AWS.

## Prerequisites

Terraform and AWS Command Line Interface tools need to be installed on your
local computer.

A previously build AMI base image with OpenVPN is required.

### Terraform

Terraform version 0.8 or higher is required.

Terraform installation instructions can be found
[here](https://www.terraform.io/intro/getting-started/install.html).

### AWS Command Line Interface

AWS Command Line Interface installation instructions can be found [here](http://docs.aws.amazon.com/cli/latest/userguide/installing.html).

### OpenVPN AMI

This module requires that an AMI base image with OpenVPN built using the recipe
from [this](https://github.com/fscm/packer-aws-openvpn) project to already
exist in your AWS account.

That AMI ID is the one that should be used as the value for the required
`ami_id` variable.

### AWS Route53 Service (optional)

If you wish to register the instances FQDN, the AWS Route53 service is also
required to be enabled and properly configured.

To register the instances FQDN on AWS Route53 service you need to set the
`private_zone_id` and/or `public_zone_id` variable(s).

## Module Input Variables

- `ami_id` - **[required]** The id of the AMI to use for the instance(s). See the [OpenVPN AMI](#openvpn-ami) section for more information.
- `associate_public_ip_address` - Associate a public IP address to the OpenVPN instance. *[default value: true]*
- `domain` - **[required]** The domain name to use for the OpenVPN instance.
- `environment` - The environment name for the OpenVPN resource(s). *[default value: '']*
- `extra_security_group_id` - Extra security group to assign to the OpenVPN instance (e.g.: 'sg-3f983f98'). *[default value: '']*
- `instance_type` - The type of instance to use for the OpenVPN instance. *[default value: 't2.small']*
- `keyname` - **[required]** The SSH key name to use for the OpenVPN instance.
- `name` - The main name for the OpenVPN resource(s). *[default value: 'openvpn']*
- `namespace` - The namespace for the OpenVPN resource(s). *[default value: '']*
- `private_zone_id` - The ID of the hosted zone for the private DNS record(s). *[default value: '']*
- `public_zone_id` - The ID of the hosted zone for the public DNS record(s). Requires `associate_public_ip_address` to be set to 'true'. *[default value: '']*
- `root_volume_iops` - The amount of provisioned IOPS (for 'io1' type only). *[default value: 0]*
- `root_volume_size` - The volume size in gigabytes. *[default value: '8']*
- `root_volume_type` - The volume type. Must be one of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). *[default value: 'gp2']*
- `stage` - The stage attribute for the OpenVPN resource(s). *[default value: '']*
- `ssh_port` - The SSH port, as defined in the original AMI from packer. *[default value: '222']*
- `subnet_ids` - **[required]** List of Subnet IDs to launch the instance in (e.g.: ['subnet-0zfg04s2','subnet-6jm2z54q']).
- `tags` - Map of tags (e.g.: '{name=test,environment=dev}'). *[default value: {}]*
- `ttl` - The TTL (in seconds) for the DNS record(s). *[default value: '600']*
- `vpc_id` - **[required]** The VPC ID for the security group(s).
- `vpn_allowed_cidrs` - **[required]** List of the subnets to which the VPN clients will be allowed access to (in CIDR notation).
- `vpn_cidr` - The subnet for the VPN clients (in CIDR notation). *[default value: '172.16.61.0/24']*
- `vpn_dns` - List of DNS Server addresses. *[default value: '[]']*


## Usage

```hcl
module "my_openvpn" {
  source                     = "github.com/fscm/terraform-module-aws-openvpn"
  ami_id                     = "ami-gxrd5hz0"
  domain                     = "mydomain.tld"
  keyname                    = "my_ssh_key"
  name                       = "openvpn"
  private_zone_id            = "Z3K95H7K1S3F"
  public_zone_id             = "Z1FA3K2H9T7J"
  subnet_ids                 = ["subnet-0zfg04s2"]
  vpc_id                     = "vpc-3f0tb39m"
  vpn_allowed_cidrs          = ["10.0.0.0/24","10.0.1.0/24"]
}
```

## Outputs

- `allowed_cidrs` - **[type: list]** List of the subnets (in CIDR notation) to which the VPN clients will be allowed access to.
- `cidr` - **[type: string]** The subnet for the VPN clients (in CIDR notation).
- `dns` - **[type: list]** List of DNS Server addresses.
- `fqdn` - **[type: list]** List of FQDNs of the OpenVPN instance.
- `hostname` - **[type: list]** List of hostnames of the OpenVPN instance.
- `id` - **[type: list]** List of IDs of the OpenVPN instance.
- `ip` - **[type: list]** List of private IP address of the OpenVPN instance.
- `security_group` - **[type: string]** ID of the security group to be added to every instance that should allow access from the OpenVPN service.
- `ssh_key` - **[type: string]** The name of the SSH key used.
- `ssh_port` -  **[type: string]** The SSH access port.

## Service Access

This modules provides a security group that will allow access from the OpenVPN
instance.

That group will allow access to the following ports to all the AWS EC2
instances that belong to the group.  Note that by default, the original packer image uses port 222 for SSH access.

| Service    | Port   | Protocol |
|:-----------|:------:|:--------:|
| SSH        | 222    |    TCP   |
| OpenVPN    | 1194   |    UDP   |

If access to other ports is required, you can create your own security group
and add it to the OpenVPN service instance using the `extra_security_group_id`
variable.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details on how
to contribute to this project.

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/terraform-module-aws-openvpn/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/terraform-module-aws-openvpn/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details
