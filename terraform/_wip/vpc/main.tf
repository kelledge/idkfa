/*
*  1) VPC aws_vpc
*  2) Internet Gateway aws_internet_gateway
*  3) Routing Tables aws_route_table, aws_route, aws_route_table_association
*  4) Subnets aws_subnet
*  5) Security Groups aws_security_group, aws_security_group_rule
*/

provider "aws" {
  region     = "us-east-1"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "route_table_private_id" {
  value = "${aws_route_table.private.id}"
}



resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}


/*
*
*/
resource "aws_subnet" "public_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

/*
*
*/
resource "aws_subnet" "private_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.private.id}"
}
