variable "name" {
  description = "Trail name"
  default     = "cloudtrail"
}

variable "s3_bucket_name" {
  description = "S3 bucket to use for storage"
}

variable "s3_key_prefix" {
  description = "Key path prefix to use for log paths. Include trailing slash. E.G 'cloudtrail/'"
  default     = "cloudtrail/"
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group"
  default     = "CloudTrail/Audit"
}

variable "data_retention_days" {
  description = "Number of days to retain audit logs"
  default     = "7"
}

data "aws_caller_identity" "current" {}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/data/cloudtrail.policy.json")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
    s3_key_prefix  = "${var.s3_key_prefix}"
  }
}

data "template_file" "cloudwatch_policy" {
  template = "${file("${path.module}/data/cloudwatch.policy.json")}"

  vars {
    // FIXME: Fix this when provider region is moved to environment variable
    region         = "us-east-1"
    account_id     = "${data.aws_caller_identity.current.account_id}"
    log_group_name = "${var.cloudwatch_log_group_name}"
  }
}

data "template_file" "cloudtrail_trust" {
  template = "${file("${path.module}/data/cloudtrail.trust.json")}"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.s3_bucket_name}"
  acl           = "private"
  // Consider if this is really needed. Will kill all logs on destroy
  force_destroy = true

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

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.cloudwatch_log_group_name}"
  retention_in_days = "${var.data_retention_days}"
}

resource "aws_iam_role" "cloudtrail" {
  name        = "cloudtrail_cloudwatch_logs_role"
  description = "CloudTrail/CloudWatch Logs Role"
  path        = "/"

  assume_role_policy = "${data.template_file.cloudtrail_trust.rendered}"
}

resource "aws_iam_policy" "cloudtrail" {
  name        = "cloudtrail_audit"
  description = "Allow CloudWatch to write to the ${var.cloudwatch_log_group_name} CloudWatch log group"
  path        = "/"

  policy = "${data.template_file.cloudwatch_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "cloudtrail" {
  role       = "${aws_iam_role.cloudtrail.name}"
  policy_arn = "${aws_iam_policy.cloudtrail.arn}"
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail"
  s3_bucket_name                = "${var.s3_bucket_name}"
  s3_key_prefix                 = "${var.s3_key_prefix}"
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true                    // set to false to pause logging

  // kms_key_id
  cloud_watch_logs_role_arn  = "${aws_iam_role.cloudtrail.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}"
}

output "cloudtrail_arn" {
  value = "${aws_cloudtrail.cloudtrail.arn}"
}

output "cloudwatch_log_group_name" {
  value = "${var.cloudwatch_log_group_name}"
}
