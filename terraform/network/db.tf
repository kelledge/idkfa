variable "vpc_id" {
  description = "The VPC where the database will be launched"
  default = ""
}

variable "route_table_id" {
  description = "The routing table to use with the database subnets"
}

output "db" {
  value = "${aws_db_instance.default}"
}

/*
*  DatabaseConnections Count
*  CPUUtilization %
*  FreeStorageSpace Bytes
*  FreeableMemory Bytes
*
* endpoint
* port
*/
resource "aws_db_instance" "default" {
  identifier                = "db1-primary"
  instance_class            = "db.t2.micro"

  allocated_storage         = 100
  storage_type              = "gp2"

  engine                    = "postgres"
  engine_version            = "9.6.2"
  parameter_group_name      = "default.postgres9.6"

  username                  = "root_user"
  password                  = "ZdOjYQyw*%98"

  backup_retention_period   = 7
  backup_window             = "08:00-08:30"         /* 03:00-03:30 CDT */
  maintenance_window        = "Sun:06:00-Sun:06:30" /* Sun:01:00-Sun:01:30 CDT */

  skip_final_snapshot       = false
  final_snapshot_identifier = "db1-primary-final"

  publicly_accessible  = false
  vpc_security_group_ids = []
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  tags = {
    Name = "main"
  }
}


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
