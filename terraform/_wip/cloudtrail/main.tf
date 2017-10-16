/*
* How to make sure that these logs are not generally viewable? Security audit
* role read only perhaps?
*/

provider "aws" {
  region     = "us-east-1"
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true // set to false to pause logging
  // kms_key_id
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "cloudtrail.kaak.us"
  acl           = "private"
  force_destroy = true // Consider if this is really needed. Will kill all logs on destroy

  policy = "${file("${path.module}/cloudtrail.policy.json")}"

  lifecycle_rule {
    id      = "cloudtrail"
    prefix  = "cloudtrail/"
    enabled = true

    expiration {
      days = 7
    }
  }
}
