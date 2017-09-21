resource "aws_iam_user" "kelledge" {
  name = "ZZZ-kelledge"
  path = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "kelledge" {
  user    = "${aws_iam_user.kelledge.name}"
  pgp_key = "${file("${path.module}/kelledge.gpg.pub")}"
}

resource "aws_iam_access_key" "kelledge" {
  user    = "${aws_iam_user.kelledge.name}"
  pgp_key = "${file("${path.module}/kelledge.gpg.pub")}"
}

output "password" {
  value = "${aws_iam_user_login_profile.kelledge.encrypted_password}"
}

output "secret" {
  value = "${aws_iam_access_key.kelledge.encrypted_secret}"
}

output "key_fingerprint" {
  value = "${aws_iam_access_key.kelledge.key_fingerprint}"
}
