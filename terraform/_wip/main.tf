provider "aws" {
  region = "us-east-1"
}


module "kelledge" {
  source = "./iam"
  username = "zzz-kelledge"
  pgp_key = "${file("${path.module}/user.gpg.pub")}"
}

output "kelledge_password" {
  value = "${module.kelledge.password}"
}

output "kelledge_access_key_id" {
  value = "${module.kelledge.access_key_id}"
}

output "kelledge_access_key_secret" {
  value = "${module.kelledge.access_key_secret}"
}


module "jsalisbury" {
  source = "./iam"
  username = "zzz-jsalisbury"
  pgp_key = "${file("${path.module}/user.gpg.pub")}"
}

output "jsalisbury_password" {
  value = "${module.jsalisbury.password}"
}

output "jsalisbury_access_key_id" {
  value = "${module.jsalisbury.access_key_id}"
}

output "jsalisbury_access_key_secret" {
  value = "${module.jsalisbury.access_key_secret}"
}








/*
module "vpc" {
  source = "./vpc"
}
*/

/*
module "rds" {
  source         = "./rds"

  vpc_id         = "${module.vpc.vpc_id}"
  route_table_id = "${module.vpc.route_table_private_id}"
}
*/

/*
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "route_table_private_id" {
  value = "${module.vpc.route_table_private_id}"
}
*/
