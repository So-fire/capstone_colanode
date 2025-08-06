resource "random_password" "shared_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}:,.<>?" # excludes '/', '@', '"', and space
}

resource "aws_secretsmanager_secret" "shared_db_secret" {
  name        = "${var.RESOURCES_PREFIX}-shared-db-secret"
  description = "Database credentials for postgresql"
}

resource "aws_secretsmanager_secret_version" "shared_db_secret_version" {
  secret_id = aws_secretsmanager_secret.shared_db_secret.id
  secret_string = jsonencode({
    db_username = var.db_username
    password    = random_password.shared_db_password.result
    db_name     = var.db_name

  })
}
