module "vpc" {
  source = "./vpc"
}

module "rds" {
  source         = "./rds"

  vpc_id         = "${module.vpc.vpc_id}"
  route_table_id = "${module.vpc.route_tables.private}"
}
