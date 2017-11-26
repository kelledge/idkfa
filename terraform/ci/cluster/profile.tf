# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
resource "aws_iam_role" "ecs_cluster" {
  name = "ecs_cluster_instance_role"
  description = "ECS Cluster Instance"
  path = "/"

  assume_role_policy = "${file("${path.module}/data/trust.json")}"
}

# AmazonEC2ContainerServiceforEC2Role
resource "aws_iam_policy" "ecs_cluster" {
  name        = "ecs_agent_policy"
  path        = "/"
  description = "Allow ECS agent limited access to ECS service"

  policy = "${file("${path.module}/data/policy.json")}"
}

resource "aws_iam_role_policy_attachment" "ecs_cluster" {
  role       = "${aws_iam_role.ecs_cluster.name}"
  policy_arn = "${aws_iam_policy.ecs_cluster.arn}"
}

resource "aws_iam_instance_profile" "ecs_cluster" {
  name  = "ecs_cluster_instance_profile"
  role = "${aws_iam_role.ecs_cluster.name}"
}

output "arn" {
  value = "${aws_iam_role.ecs_cluster.arn}"
}

output "profile" {
  value = "${aws_iam_instance_profile.ecs_cluster.id}"
}
