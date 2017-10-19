provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/enc.tfstate"
    region = "us-east-1"
  }
}

resource "aws_kms_key" "account" {
  description             = "Account KMS Key"
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "account" {
  name          = "alias/account-key"
  target_key_id = "${aws_kms_key.account.key_id}"
}
