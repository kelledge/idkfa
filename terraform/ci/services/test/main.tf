provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket     = "state.kaak.us"
    key        = "terraform/ci/services/test.tfstate"
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

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/ci/cluster.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "lb" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/ci/lb.tfstate"
    region = "us-east-1"
  }
}

/*
* ALB
*/
resource "aws_lb_target_group" "test_service" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.network.vpc_id}"
}

resource "aws_lb_listener_rule" "test_service" {
  listener_arn = "${data.terraform_remote_state.lb.http_listener_arn}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test_service.arn}"
  }

  condition {
    field  = "host-header"
    values = ["test-service.kaak.us"]
  }
}

/*data "terraform_remote_state" "lb" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/ci/lb.tfstate"
    region = "us-east-1"
  }
}
* ECS
*/
resource "aws_ecs_task_definition" "echo" {
  family = "echo"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "essential": true,
    "image": "brndnmtthws/nginx-echo-headers:latest",
    "memory": 128,
    "memoryReservation": 64,
    "name": "echo",
    "portMappings": [
      {
        "containerPort": 8080
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "echo" {
  name            = "echo"
  cluster         = "${data.terraform_remote_state.cluster.name}"
  task_definition = "${aws_ecs_task_definition.echo.arn}"
  desired_count   = 3
  # iam_role        = "${aws_iam_role.foo.arn}"
  # depends_on      = ["aws_iaterraform.iom_role_policy.foo"]

  # placement_strategy {name
  #   type  = "binpack"
  #   field = "cpu"
  # }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.test_service.arn}"
    container_name = "echo"
    container_port = 8080
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}
