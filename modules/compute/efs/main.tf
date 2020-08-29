resource "aws_efs_file_system" "aws_efs" {
  encrypted                       = var.aws_efs_encrypted
  performance_mode                = var.aws_efs_performance_mode
  provisioned_throughput_in_mibps = var.aws_efs_provisioned_throughput_in_mibps
  throughput_mode                 = var.aws_efs_throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.aws_efs_transition_to_ia == "" ? [] : [1]
    content {
      transition_to_ia = var.aws_efs_transition_to_ia
    }
  }
}

resource "aws_efs_mount_target" "aws_efs_mount" {
  file_system_id  = join("", aws_efs_file_system.aws_efs.*.id)
  subnet_id       = var.aws_subnets
  security_groups = [var.aws_efs_sg]
}