resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${aws_iam_policy.rotate_keys.arn}"
}

resource "aws_iam_group_membership" "developers" {
  name = "developers"
  group = "${aws_iam_group.developers.name}"

  users = [
    "${module.jsalisbury.name}",
    "${module.kelledge.name}"
  ]
}

/*
*
*/
resource "aws_iam_group" "administrators" {
  name = "administrators2"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = "${aws_iam_group.administrators.name}"
  policy_arn = "${aws_iam_policy.administrator_assume.arn}"
}

resource "aws_iam_group_membership" "administrators" {
  name = "administrators2"
  group = "${aws_iam_group.administrators.name}"

  users = [
    "${module.kelledge.name}"
  ]
}
