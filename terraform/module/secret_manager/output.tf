output "secret_arn" {
  value = aws_secretsmanager_secret.shared_db_secret.arn
}

output "secret_password" {
  value     = jsondecode(aws_secretsmanager_secret_version.shared_db_secret_version.secret_string)["password"]
  sensitive = true
}

