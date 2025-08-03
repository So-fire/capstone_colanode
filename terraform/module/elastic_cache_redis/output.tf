output "valkey_endpoint" {
  value = aws_elasticache_cluster.valkey.cache_nodes[0].address
}

output "valkey_port" {
  value = aws_elasticache_cluster.valkey.cache_nodes[0].port
}
