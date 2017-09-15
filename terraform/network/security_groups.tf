resource "aws_security_group" "main" {
  name        = "nodes.z.petropower.com"
  vpc_id      = "vpc-59c6663c"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "z.petropower.com"
    Name              = "nodes.z.petropower.com"
  }
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.main.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.main.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
