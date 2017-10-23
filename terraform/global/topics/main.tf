provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/topics.tfstate"
    region = "us-east-1"
  }
}

/*
* Given their importance, I should probably specify delivery policies for these
* topics.
*/
resource "aws_sns_topic" "critical" {
  name = "critical"
  display_name = "Critical events requiring urgent attention"
}

resource "aws_sns_topic" "warn" {
  name = "warn"
  display_name = "Warning events that will become critical without attention"
}

resource "aws_sns_topic" "info" {
  name = "info"
  display_name = "Information events"
}

output "critical_arn" {
  value = "${aws_sns_topic.critical.arn}"
}

output "warn_arn" {
  value = "${aws_sns_topic.warn.arn}"
}

output "info_arn" {
  value = "${aws_sns_topic.info.arn}"
}
