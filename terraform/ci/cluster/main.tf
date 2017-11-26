provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket     = "state.kaak.us"
    key        = "terraform/ci/cluster.tfstate"
    region     = "us-east-1"
  }
}

data "terraform_remote_state" "lb" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/ci/lb.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/network.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"]
}

module "cluster_key" {
  source = "../../modules/ssh-key"
  key_name = "ECS Cluster Keypair"
  key_path = "${path.module}/id_cluster"
}


# instance_profile
# ssh key
# SGs

module "c1" {
  source               = "github.com/segmentio/stack/ecs-cluster"
  environment          = "test"
  name                 = "c1"
  vpc_id               = "${data.terraform_remote_state.network.vpc_id}"
  image_id             = "${data.aws_ami.ecs.image_id}"
  subnet_ids           = "${data.terraform_remote_state.network.external_subnets}"
  key_name             = "${module.cluster_key.key_name}"
  # FIXME: These security groups are added as allowed ingress sources. This is
  # great for intra-service traffic like ALB and ECS, but not so great for SSH.
  security_groups      = "${join(",", list(
    data.terraform_remote_state.network.intranet_sg_id,
    data.terraform_remote_state.network.web_sg_id,
    data.terraform_remote_state.network.ssh_sg_id
  ))}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster.id}"
  region               = "us-east-1"
  availability_zones   = "${data.terraform_remote_state.network.availability_zones}"
  instance_type        = "t2.small"
  instance_ebs_optimized = false
}

// The cluster name, e.g cdn
output "name" {
  value = "${module.c1.name}"
}

// The cluster security group ID.
output "security_group_id" {
  value = "${module.c1.security_group_id}"
}
