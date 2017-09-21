module "iam" {
  source = "./iam"
}

output "password" {
  value = "${module.iam.password}"
}

output "secret" {
  value = "${module.iam.secret}"
}

output "key_fingerprint" {
  value = "${module.iam.key_fingerprint}"
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
