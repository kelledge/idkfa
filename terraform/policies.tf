data "aws_caller_identity" "current" {}

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
