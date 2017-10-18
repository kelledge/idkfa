variable "name" {
  type = "string"
  description = "Name of group"
}

variable "path" {
  type = "string"
  description = "IAM path"
  default = "/"
}

variable "member_names" {
  type = "list"
  description = "List of user names that are members of this group"
  default = []
}

variable "policy_arns" {
  type = "list"
  description = "List of policy ARNs to associate to this group"
  default = []
}

resource "aws_iam_group" "group" {
  name = "${var.name}"
  path = "${var.path}"
}

resource "aws_iam_group_policy_attachment" "group" {
  count      = "${length(var.policy_arns)}"
  group      = "${aws_iam_group.group.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
}

resource "aws_iam_group_membership" "group" {
  name = "${aws_iam_group.group.name}-members"
  group = "${aws_iam_group.group.name}"

  users = "${var.member_names}"
}

output "group_id" {
  value = "${aws_iam_group.group.group_id}"
}

output "arn" {
  value = "${aws_iam_group.group.arn}"
}
