variable "project_name" {}
variable "environment" {}
variable "ec2_instance_type" {}
variable "vpc_id" {}
variable "region" {}

variable "PUBLIC_EC2_SG_ID" {}
variable "PRIVATE_EC2_SG_ID" {}

variable "PUBLIC_EC2_INSTANCE_PROFILE_NAME" {}
variable "PRIVATE_EC2_INSTANCE_PROFILE_NAME" {}

variable "public_subnet_ids" {
  description = "Subnet ID where EC2 will be launched"
  type        = list(string)
}
# # variable "db_name" {}
variable "private_subnet_ids" {}

variable "rds_endpoint" {}
variable "rds_port" {}
variable "shared_db_secret_name"{}