data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "bastion" {
  ami = "ami-1d4e7a66"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }

  # iam_instance_profile
  # source_dest_check
  # user_data

  tags = {
    Name = "terraform_bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("${path.module}/id_rsa.pub")}"
}
