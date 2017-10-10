data "aws_caller_identity" "current" {}

locals {
  administrator_access_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

/*
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}
*/

/*
* Simple user self administration
*/
data "template_file" "rotate_keys_policy" {
  template = "${file("${path.module}/data/rotate_keys.policy.json")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "rotate_keys" {
  name        = "rotate_keys"
  path        = "/"
  description = "Allow users to rotate their access keys"

  policy = "${data.template_file.rotate_keys_policy.rendered}"
}

/*
* Administrator Role and supporting resources
*/
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
  description = "Administrator Access Role"
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

/*
* Bastion instance role and profiles
*/
resource "aws_iam_role" "bastion" {
    name = "bastion_instance_role"
    description = "Bastion Instance Role"
    path = "/"

    assume_role_policy = "${file("${path.module}/data/bastion.trust.json")}"
}

resource "aws_iam_policy" "bastion" {
  name        = "bastion_instance_policy"
  path        = "/"
  description = "Bastion Permission Policy"

  policy = "${file("${path.module}/data/bastion.policy.json")}"
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = "${aws_iam_role.bastion.name}"
  policy_arn = "${aws_iam_policy.bastion.arn}"
}

resource "aws_iam_instance_profile" "bastion" {
  name  = "bastion_instance_profile"
  role = "${aws_iam_role.bastion.name}"
}
