provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "state.kaak.us"
    key    = "terraform/global/alarms.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "topics" {
  backend = "s3"

  config {
    bucket = "state.kaak.us"
    key    = "terraform/global/topics.tfstate"
    region = "us-east-1"
  }
}
