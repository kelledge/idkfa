provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket     = "state.kaak.us"
    key        = "terraform/ci/lb.tfstate"
    region     = "us-east-1"
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

# Create a new application load balancer
resource "aws_lb" "ingress" {
  name            = "test-lb"
  internal        = false
  security_groups = [
    "${data.terraform_remote_state.network.intranet_sg_id}",
    "${data.terraform_remote_state.network.web_sg_id}",
    "${data.terraform_remote_state.network.ssh_sg_id}"
  ]
  subnets         = ["${data.terraform_remote_state.network.external_subnets}"]

  # There are many customer-facing details associated with this resource like
  # DNS records and SSL certificates. When we destroy it, we want to be sure it
  # is on purpose.
  enable_deletion_protection = true

  # TODO: Enable access logs
  # access_logs {
  #   bucket = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix = "test-lb"
  # }

  tags {
    Environment = "test"
  }
}

# TODO: Make this host a HTTP -> HTTPS redirect based on X-Forwarded-Proto
resource "aws_lb_target_group" "default" {
  name     = "default-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.network.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.ingress.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "arn" {
  value = "${aws_lb.ingress.arn}"
}

output "dns_name" {
  value = "${aws_lb.ingress.dns_name}"
}

output "http_listener_arn" {
  value = "${aws_lb_listener.http.arn}"
}

output "http_listener_default_target_group_arn" {
  value = "${aws_lb_target_group.default.arn}"
}
