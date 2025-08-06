data "aws_rds_engine_version" "postgres" {
  engine = "postgres"
}


resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier            = "${var.project_name}-${var.environment}-db"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine                = "postgres"
  engine_version        = data.aws_rds_engine_version.postgres.version
  instance_class        = var.instance_class
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  port                  = 5432

  vpc_security_group_ids = [var.POSTGRESQL_SG_ID]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false
  backup_retention_period = 7



  tags = {
    Name        = "${var.project_name}-postgres-rds"
    Environment = var.environment
  }
}

