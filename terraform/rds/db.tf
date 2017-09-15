variable "vpc_id" {
  description = "The VPC where the database will be launched"
}

variable "route_table_id" {
  description = "The routing table to use with the database subnets"
}

/*
output "db" {
  value = "${aws_db_instance.default.endpoint}"
}
*/

/*
*
*/
resource "aws_subnet" "db-a" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.0.64.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "db-a" {
  subnet_id      = "${aws_subnet.db-a.id}"
  route_table_id = "${var.route_table_id}"
}

/*
*
*/
resource "aws_subnet" "db-b" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.0.96.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "db-b" {
  subnet_id      = "${aws_subnet.db-b.id}"
  route_table_id = "${var.route_table_id}"
}

/*
*
*/
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.db-a.id}", "${aws_subnet.db-b.id}"]

  tags {
    Name = "main"
  }
}
