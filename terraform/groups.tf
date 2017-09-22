resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${aws_iam_policy.rotate_keys.arn}"
}

resource "aws_iam_group_membership" "developers" {
  name = "tf-testing-group-membership"

  users = [
    "${module.jsalisbury.name}",
    "${module.kelledge.name}"
  ]

  group = "${aws_iam_group.developers.name}"
}
