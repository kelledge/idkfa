module "vpc" {
  source = "./vpc"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "route_table_private_id" {
  value = "${module.vpc.route_table_private_id}"
}


module "rds" {
  source         = "./rds"

  vpc_id         = "${module.vpc.vpc_id}"
  route_table_id = "${module.vpc.route_table_private_id}"
}
