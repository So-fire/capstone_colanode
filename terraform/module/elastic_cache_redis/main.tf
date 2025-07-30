resource "aws_elasticache_subnet_group" "valkey_subnet_group" {
  name       = "${var.project_name}-valkey-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "valkey" {
  cluster_id           = "${var.project_name}-valkey"
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids   = [var.VALKEY_SG_ID]

  tags = {
    Name = "${var.project_name}-valkey"
  }
}
