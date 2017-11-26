provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/dns.tfstate"
    region = "us-east-1"
  }
}

resource "aws_route53_zone" "organization" {
  name = "kevinelledge.com"
  comment = "Organization domain"
}

resource "aws_route53_record" "acm_validation" {
  zone_id = "${aws_route53_zone.organization.zone_id}"
  name    = "_bffe768ebad1b637fb50818074538bd8.kevinelledge.com"
  type    = "CNAME"
  ttl     = "5"

  records        = ["_07a1e838220548d494b22e8570b3b1e1.acm-validations.aws"]
}

output "zone_id" {
  value = "${aws_route53_zone.organization.zone_id}"
}

output "name_servers" {
  value = "${aws_route53_zone.organization.name_servers}"
}
