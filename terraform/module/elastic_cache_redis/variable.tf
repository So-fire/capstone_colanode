variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "VALKEY_SG_ID" {}