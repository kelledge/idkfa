terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/audit.tfstate"
    region = "us-east-1"
  }
}

module "audit" {
  source              = "../../modules/cloudtrail"

  s3_bucket_name      = "audit.kaak.us"
  s3_key_prefix       = "cloudtrail/"
  data_retention_days = 2
}
