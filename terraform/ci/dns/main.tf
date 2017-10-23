provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/ci/dns.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/global/dns.tfstate"
    region = "us-east-1"
  }
}

resource "aws_route53_zone" "ci" {
  name = "ci.kaak.us"
  comment = "CI domain"

  tags {
    Environment = "ci"
  }
}

/*
* Create delegation set records
*/
resource "aws_route53_record" "ci_ns" {
  zone_id = "${data.terraform_remote_state.dns.zone_id}"
  name    = "ci.kaak.us"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.ci.name_servers.0}",
    "${aws_route53_zone.ci.name_servers.1}",
    "${aws_route53_zone.ci.name_servers.2}",
    "${aws_route53_zone.ci.name_servers.3}",
  ]
}

output "zone_id" {
  value = "${aws_route53_zone.ci.zone_id}"
}

output "name_servers" {
  value = "${aws_route53_zone.ci.name_servers}"
}
