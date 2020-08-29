resource "aws_rds_cluster" "aws_aurora_cluster" {
  cluster_identifier      = var.aws_rds_cluster_id
  engine                  = var.aws_rds_engin_name
  engine_version          = var.aws_rds_engin_version
  availability_zones      = ["ap-northeast-2a", "ap-northeast-2c"]
  db_subnet_group_name    = var.aws_rds_subnet_group_id
  vpc_security_group_ids  = var.aws_rds_sg_id
  db_cluster_parameter_group_name = var.aws_rds_cluster_parm_group_name
  database_name           = var.aws_rds_database_name
  master_username         = var.aws_rds_master_username
  master_password         = var.aws_rds_master_password
  backup_retention_period = var.aws_rds_backup_period
  preferred_backup_window = var.aws_rds_backup_window
  skip_final_snapshot = true

}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.replica_scale_enabled ? var.aws_rds_replica_scale_min : var.aws_rds_replica_count

  identifier         = "${aws_rds_cluster.aws_aurora_cluster.cluster_identifier}-${count.index}"
  cluster_identifier = aws_rds_cluster.aws_aurora_cluster.id
  instance_class     = var.aws_rds_instance_class
  engine             = aws_rds_cluster.aws_aurora_cluster.engine
  engine_version     = aws_rds_cluster.aws_aurora_cluster.engine_version
}

resource "aws_appautoscaling_target" "read_replica_count" {
  count = var.replica_scale_enabled ? 1 : 0

  max_capacity       = var.aws_rds_replica_scale_max
  min_capacity       = var.aws_rds_replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.aws_aurora_cluster.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}
