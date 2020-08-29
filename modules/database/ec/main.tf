resource "aws_elasticache_replication_group" "aws_es_redis" {
  automatic_failover_enabled    = true
  replication_group_id          = var.aws_es_rg_id
  replication_group_description = "qa envrionment"
  security_group_ids            = var.aws_es_sg_id
  subnet_group_name             = var.aws_es_subnet_name
  node_type                     = var.aws_es_node_type
  number_cache_clusters         = var.aws_es_number_cache_clusters_enable == true ? 2 : 0
  parameter_group_name          = var.aws_es_redis_parameter_group_name
  engine_version                = var.aws_es_engine_version
  port                          = 6379

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"]  : [] 
    content {
      replicas_per_node_group = var.aws_cluster_mode_replicas_per_node_group
      num_node_groups         = var.aws_cluster_mode_num_node_groups
    }
  }
}
