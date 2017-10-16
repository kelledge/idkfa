provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/network.tfstate"
    region = "us-east-1"
  }
}

module "network" {
  source             = "../../modules/vpc"

  name               = "network"
  cidr               = "10.0.0.0/16"
  external_subnets   = ["10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
  internal_subnets   = ["10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]
  environment        = "ci"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

// FIXME: For some reason, this always dereferences to the current date ...
output "id" {
  value = "${module.network.id}"
}

// NOTE: Added as work around to the above FIXME. Probably will drop id in favor
// of vpc_id anyway. It is more clear.
output "vpc_id" {
  value = "${module.network.id}"
}

// A comma-separated list of subnet IDs.
output "external_subnets" {
  value = "${module.network.external_subnets}"
}

// A list of subnet IDs.
output "internal_subnets" {
  value = "${module.network.internal_subnets}"
}

// The default VPC security group ID.
output "security_group" {
  value = "${module.network.security_group}"
}

// The list of availability zones of the VPC.
output "availability_zones" {
  value = "${module.network.availability_zones}"
}

// The internal route table ID.
output "internal_rtb_id" {
  value = "${module.network.internal_rtb_id}"
}

// The external route table ID.
output "external_rtb_id" {
  value = "${module.network.external_rtb_id}"
}

output "intranet_sg_id" {
  value = "${aws_security_group.intranet.id}"
}

output "ssh_sg_id" {
  value = "${aws_security_group.ssh.id}"
}

output "weg_sg_id" {
  value = "${aws_security_group.web.id}"
}
