output "endpoint" {
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.aws_ec_redis.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.aws_ec_redis.*.primary_endpoint_address)
}