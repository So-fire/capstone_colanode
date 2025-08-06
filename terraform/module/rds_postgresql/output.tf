
output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_port" {
  value = aws_db_instance.this.port
}

output "latest_postgres_version" {
  value = data.aws_rds_engine_version.postgres.version
}
################################################3

output "rds_db_name" {
  value = aws_db_instance.this.db_name
}

# output "rds_username" {
#   value = aws_db_instance.this.username
# }

# output "rds_password" {
#   value     = random_password.rds_master_password.result
#   sensitive = true
# }
