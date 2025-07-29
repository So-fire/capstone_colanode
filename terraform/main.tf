terraform {
  required_version = ">= 1.3.0"
  }


module "vpc" {
  source = "./module/vpc"

  default_route = var.default_route
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  environment   = var.environment
}
