resource "aws_security_group" "main" {
  name        = "main"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Main security group"

  tags = {
    Name = "main"
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

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.main.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.main.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
