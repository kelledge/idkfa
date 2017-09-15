resource "aws_db_instance" "default" {
  name                 = "mydb"

  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.2"
  instance_class       = "db.t1.micro"


  username             = "foo"
  password             = "bar"

  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  parameter_group_name = "default.mysql5.6"
  publicly_accessible  = false
  skip_final_snapshot  = false

  vpc_security_group_ids

  tags = {
    Name = "main"
  }
}
