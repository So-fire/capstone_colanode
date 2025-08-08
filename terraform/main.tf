terraform {
  required_version = ">= 1.3.0"
}

resource "random_id" "s3_suffix" {
  byte_length = 4
}

locals {
  RESOURCES_PREFIX = "${lower(var.ENV)}-colanode"
  ACCOUNTID        = data.aws_caller_identity.current.account_id
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

# module "s3" {
#   source           = "./module/s3"
#   RESOURCES_PREFIX = local.RESOURCES_PREFIX
#   bucket_name      = "${local.RESOURCES_PREFIX}-bucket-${random_id.s3_suffix.hex}"
# }


module "role" {
  source = "./module/role"

  ENV          = var.ENV
  region       = var.region
  project_name = var.project_name

}

module "policy" {
  source = "./module/policy"

  ENV                   = var.ENV
  region                = var.region
  project_name          = var.project_name
  PUBLIC_EC2_ROLE_NAME  = module.role.PUBLIC_EC2_ROLE_NAME
  PRIVATE_EC2_ROLE_NAME = module.role.PRIVATE_EC2_ROLE_NAME
}

module "ec2" {
  source = "./module/ec2"

  project_name = var.project_name
  #   depends_on                        = [module.rds]
  environment                       = var.environment
  vpc_id                            = module.vpc.vpc_id
  region                            = var.region
  ec2_instance_type                 = var.ec2_instance_type
  PUBLIC_EC2_SG_ID                  = [module.security_group.PUBLIC_EC2_SG_ID]
  PRIVATE_EC2_SG_ID                 = [module.security_group.PRIVATE_EC2_SG_ID]
  PUBLIC_EC2_INSTANCE_PROFILE_NAME  = module.role.PUBLIC_EC2_INSTANCE_PROFILE_NAME
  PRIVATE_EC2_INSTANCE_PROFILE_NAME = module.role.PRIVATE_EC2_INSTANCE_PROFILE_NAME
  public_subnet_ids                 = module.vpc.public_subnet_ids
  private_subnet_ids                = module.vpc.private_subnet_ids
  depends_on                        = [module.secret_manager, module.rds_postgresql]
  rds_endpoint                      = module.rds_postgresql.rds_endpoint
  rds_port                          = module.rds_postgresql.rds_port
}


module "security_group" {
  source = "./module/security_group"

  project_name  = var.project_name
  vpc_id        = module.vpc.vpc_id
  environment   = var.environment
  default-route = var.default-route
  vpc_cidr      = var.vpc_cidr
}

module "rds_postgresql" {
  source       = "./module/rds_postgresql"
  project_name = var.project_name
  environment  = var.environment

  db_name     = module.secret_manager.db_name
  db_username = module.secret_manager.db_username
  db_password = module.secret_manager.secret_password


  instance_class        = var.db_instance_class
  allocated_storage     = 20
  max_allocated_storage = 100

  database_subnet_ids = module.vpc.database_subnet_ids
  POSTGRESQL_SG_ID    = module.security_group.POSTGRESQL_SG_ID
  depends_on          = [module.secret_manager]

}

module "elastic_cache_redis" {
  source = "./module/elastic_cache_redis"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  VALKEY_SG_ID       = module.security_group.VALKEY_SG_ID
}

module "secret_manager" {
  source           = "./module/secret_manager"
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
  db_username      = var.db_username
  db_name          = var.db_name

}