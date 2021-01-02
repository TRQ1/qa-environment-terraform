locals {

  // 클러스터가 아닌 경우 node_count = replica cluster_size 가 갯수이고, 클러스터인 경우 node_count = shard*(replica + 1) 이된다.
  member_clusters_count = (var.cluster_mode_enabled
    ?
    (var.cluster_mode_num_node_groups * (var.cluster_mode_replicas_per_node_group + 1))
    :
    var.cluster_size
  )
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.enabled ? 1 : 0
  name   = var.aws_ec_rg_id
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_replication_group" "aws_ec_redis" {
  count = var.enabled ? 1 : 0

  automatic_failover_enabled    = var.aws_ec_automatic_failover_enabled
  replication_group_id          = var.aws_ec_rg_id
  replication_group_description = var.aws_ec_replication_group_desciption
  security_group_ids            = var.aws_ec_sg_id
  subnet_group_name             = var.aws_ec_subnet_name
  node_type                     = var.aws_ec_node_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  parameter_group_name          = join("", aws_elasticache_parameter_group.default.*.name)
  engine_version                = var.aws_ec_engine_version
  port                          = 6379

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"]  : [] 
    content {
      replicas_per_node_group = var.aws_cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }
}
