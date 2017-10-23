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
  name = "kaak.us"
  comment = "Organization domain"
}

output "zone_id" {
  value = "${aws_route53_zone.organization.zone_id}"
}

output "name_servers" {
  value = "${aws_route53_zone.organization.name_servers}"
}
