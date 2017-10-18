provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/roles.tfstate"
    region = "us-east-1"
  }
}

locals {
  administrator_access_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_caller_identity" "current" {}

data "template_file" "administrator_trust_policy" {
  template = "${file("${path.module}/data/administrator.trust_policy.json")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

data "template_file" "administrator_assume" {
  template = "${file("${path.module}/data/administrator_assume.policy.json")}"

  vars {
    role_arn = "${aws_iam_role.administrator_role.arn}"
  }
}

resource "aws_iam_role" "administrator_role" {
  name = "administrator_role"
  description = "Administrator access role"
  path = "/"

  assume_role_policy = "${data.template_file.administrator_trust_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "administrator_role" {
  role       = "${aws_iam_role.administrator_role.name}"
  policy_arn = "${local.administrator_access_policy_arn}"
}

resource "aws_iam_policy" "administrator_assume" {
  name        = "administrator_assume"
  path        = "/"
  description = "Allow user to assume administrator role"

  policy = "${data.template_file.administrator_assume.rendered}"
}

output "administrator_role_arn" {
  value = "${aws_iam_role.administrator_role.arn}"
}

output "administrator_assume_policy_arn" {
  value = "${aws_iam_policy.administrator_assume.arn}"
}
