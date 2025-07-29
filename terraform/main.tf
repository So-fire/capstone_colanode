terraform {
  required_version = ">= 1.3.0"
}

locals {
  RESOURCES_PREFIX = "${lower(var.ENV)}-tenant-premium-ehrs"
  AWS_REGION       = data.aws_region.current.id

  common_tags = {
    environment = var.ENV
    project     = "colanode"
  }
}


module "vpc" {
  source = "./module/vpc"

  default_route = var.default_route
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  environment   = var.environment
}

module "s3" {
  source           = "./module/s3"
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
  bucket_name      = "${local.RESOURCES_PREFIX}-bucket-${random_id.s3_suffix.hex}"
}