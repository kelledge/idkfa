variable "pgp_key" {}
variable "username" {}
variable "path" {
  default = "/"
}


resource "aws_iam_user" "user" {
  name = "${var.username}"
  path = "${var.path}"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user" {
  user    = "${aws_iam_user.user.name}"
  pgp_key = "${var.pgp_key}"
}

resource "aws_iam_access_key" "user" {
  user    = "${aws_iam_user.user.name}"
  pgp_key = "${var.pgp_key}"
}


output "id" {
  value = "${aws_iam_user.user.id}"
}

output "arn" {
  value = "${aws_iam_user.user.arn}"
}

output "name" {
  value = "${aws_iam_user.user.name}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.user.access_key.id}"
}

output "access_key_secret" {
  value = "${aws_iam_access_key.user.encrypted_secret}"
}

output "password" {
  value = "${aws_iam_user_login_profile.user.encrypted_password}"
}

/*
output "user_1" {
  value = "${
    map(
      "key_fp", "${aws_iam_access_key.user_1.key_fingerprint}",
      "password", "${aws_iam_user_login_profile.user_1.encrypted_password}",
      "access_key_id", "${aws_iam_access_key.user_1.id}",
      "access_key_secret", "${aws_iam_access_key.user_1.encrypted_secret}"
    )
  }"
}
*/
