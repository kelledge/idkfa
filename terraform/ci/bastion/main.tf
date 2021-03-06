provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/bastion.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/network.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/ci/dns.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "topics" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/global/topics.tfstate"
    region = "us-east-1"
  }
}

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

resource "aws_key_pair" "bastion" {
  key_name   = "bastion_key"
  public_key = "${file("${path.module}/id_rsa.pub")}"
}

module "bastion" {
  source = "../../modules/bastion"

  instance_type = "t2.micro"
  ami_id        = "${data.aws_ami.ubuntu.image_id}"
  key_name      = "${aws_key_pair.bastion.key_name}"

  vpc_id    = "${data.terraform_remote_state.network.vpc_id}"
  subnet_id = "${data.terraform_remote_state.network.external_subnets[0]}"

  security_groups = "${join(",", list(
    data.terraform_remote_state.network.ssh_sg_id,
    data.terraform_remote_state.network.intranet_sg_id
  ))}"

  environment = "ci"
}

resource "aws_route53_record" "bastion" {
  zone_id = "${data.terraform_remote_state.dns.zone_id}"
  name    = "bastion.ci.kaak.us"
  type    = "A"
  ttl     = "300"
  records = ["${module.bastion.external_ip}"]
}

resource "aws_cloudwatch_metric_alarm" "bastion" {
  alarm_name          = "bastion"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"

  dimensions {
    InstanceId = "${module.bastion.instance_id}"
  }

  alarm_description = "This metric monitors bastion ec2 status check"
  alarm_actions     = ["${data.terraform_remote_state.topics.critical_arn}"]
}


output "instance_id" {
  value = "${module.bastion.instance_id}"
}

output "external_ip" {
  value = "${module.bastion.external_ip}"
}

output "internal_ip" {
  value = "${module.bastion.internal_ip}"
}
