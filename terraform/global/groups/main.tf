provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/groups.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "policies" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/global/policies.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "roles" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/global/roles.tfstate"
    region = "us-east-1"
  }
}

module "users" {
  source = "../../modules/iam-group"
  name = "users"
  policy_arns = [
    "${data.terraform_remote_state.policies.self_manage_credentials_arn}"
  ]
}

module "administrators" {
  source = "../../modules/iam-group"
  name = "administrators"
  policy_arns = [
    "${data.terraform_remote_state.roles.administrator_assume_policy_arn}"
  ]
}

output "users_id" {
  value = "${module.users.group_id}"
}

output "users_arn" {
  value = "${module.users.arn}"
}

output "administrators_id" {
  value = "${module.administrators.group_id}"
}

output "administrators_arn" {
  value = "${module.administrators.arn}"
}
