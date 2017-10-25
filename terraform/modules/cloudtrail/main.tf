variable "name" {
  description = "Trail name"
  default = "cloudtrail"
}

variable "s3_bucket_name" {
  description = "S3 bucket to use for storage"
}

variable "s3_key_prefix" {
  description = "Key path prefix to use for log paths. Include trailing slash. E.G 'cloudtrail/'"
  default = "cloudtrail/"
}

variable "data_retention_days" {
  description = "Number of days to retain audit logs"
  default = "7"
}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/data/cloudtrail.policy.json")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
    s3_key_prefix = "${var.s3_key_prefix}"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.s3_bucket_name}"
  acl           = "private"
  force_destroy = true // Consider if this is really needed. Will kill all logs on destroy

  policy = "${data.template_file.bucket_policy.rendered}"

  lifecycle_rule {
    id      = "cloudtrail-retention-policy"
    prefix  = "${var.s3_key_prefix}"
    enabled = true

    expiration {
      days = "${var.data_retention_days}"
    }
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail"
  s3_bucket_name                = "${var.s3_bucket_name}"
  s3_key_prefix                 = "${var.s3_key_prefix}"
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true // set to false to pause logging
  // kms_key_id
}
