provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/db.tfstate"
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

module "db" {
  source = "../../modules/rds"
  name = "ci-database"
  storage_type = "gp2"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  engine = "postgres"
  engine_version = "9.5.7"
  port = 5432
  database = "cidb"
  username = "root_user"
  password = "v6otpxUgDjX49s01aUCB"
  multi_az = false
  backup_retention_period = 5
  // backup_window
  // maintenance_window
  // monitoring_interval
  // monitoring_role_arn
  apply_immediately = true
  publicly_accessible = false
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
  // vpc_id = "vpc-1e2fe666"
  ingress_allow_security_groups = ["${data.terraform_remote_state.network.intranet_sg_id}"]
  // ingress_allow_cidr_blocks
  subnet_ids = "${data.terraform_remote_state.network.internal_subnets}"
}

output "addr" {
  value = "${module.db.addr}"
}

output "url" {
  value = "${module.db.url}"
}
