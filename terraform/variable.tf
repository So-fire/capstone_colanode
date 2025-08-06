variable "region" {
  default = "us-east-1"
}

variable "ENV" {
  type    = string
  default = "dev"
}

# variable "bucket_name" {
#   type    = string
#   default = "my-terraform-state-bucket"

# }

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "colanode"
}

variable "default-route" {
  description = "default"
  type        = string
  default     = "0.0.0.0/0"
}

###=============================================
#  VPC CIDR BLOCK VARIABLES
###============================================
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

###=============================================
#  ROUTE VARIABLES
###============================================
variable "default_route" {
  description = "Default route for route tables"
  type        = string
  default     = "0.0.0.0/0"
}
###=============================================
#  INSTANCE TYPES VARIABLES
###============================================
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

}

###=============================================
#  RDS VARIABLES
###============================================
# variable "db_name" {
#   description = "Name of the RDS database"
#   type        = string
#   default     = "postgres"

# }

# variable "db_username" {
#   description = "Username for the RDS database"
#   type        = string
#   default     = "postgres"
# }

# variable "db_password" {
#   description = "Username for the postgre RDS database" #never do tis ever, tis is just for practice
#   type        = string
#   default     = "postgres"
# }

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

