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
  external_subnets   = ["10.0.0.0/24"]
  internal_subnets   = ["10.0.1.0/24"]
  environment        = "ci"
  availability_zones = ["us-east-1a"]
}

output "id" {
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
