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
  name = "ci.kevinelledge.com"
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
  name    = "ci.kevinelledge.com"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.ci.name_servers.0}",
    "${aws_route53_zone.ci.name_servers.1}",
    "${aws_route53_zone.ci.name_servers.2}",
    "${aws_route53_zone.ci.name_servers.3}",
  ]
}

/*
* NOTE: I am leaving these with the zone for now, but it may make more sense to
* locate these records closer to the ACM references.
*/
resource "aws_route53_record" "acm_validation" {
  zone_id = "${aws_route53_zone.ci.zone_id}"
  name    = "_4c94d5d5bb364e3f81ce04aec27bd3c8.ci.kevinelledge.com"
  type    = "CNAME"
  ttl     = "5"

  records        = ["_a17bf2f402f079a47f7daf6828e00a61.acm-validations.aws"]
}

output "zone_id" {
  value = "${aws_route53_zone.ci.zone_id}"
}

output "name_servers" {
  value = "${aws_route53_zone.ci.name_servers}"
}
