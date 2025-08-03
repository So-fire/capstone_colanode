
output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_port" {
  value = aws_db_instance.this.port
}

output "latest_postgres_version" {
  value = data.aws_rds_engine_version.postgres.version
}