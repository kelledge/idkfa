provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/policies.tfstate"
    region = "us-east-1"
  }
}

/*
* Provides the usefule account_id variable needed by many policies
*/
data "aws_caller_identity" "current" {}

/*
* Simple user self administration
*/
data "template_file" "self_manage_credentials" {
  template = "${file("${path.module}/data/self_manage_credentials.policy.json")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "self_manage_credentials" {
  name        = "self_manage_credentials"
  path        = "/"
  description = "Allow users to self-manage their account credentials"

  policy = "${data.template_file.self_manage_credentials.rendered}"
}

output "self_manage_credentials_arn" {
  value = "${aws_iam_policy.self_manage_credentials.arn}"
}
