variable "project_name" {}
variable "environment" {}
variable "POSTGRESQL_SG_ID" {}


variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}

variable "allocated_storage" {
  default = 20
}
variable "max_allocated_storage" {
  default = 100
}
variable "instance_class" {
  default = "db.t3.micro"
}

variable "database_subnet_ids" {
  type = list(string)
}


