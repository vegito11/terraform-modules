module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  name        = "${var.environment}-${var.db_name}-DB-SG"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  tags = {
    Name = "${var.environment}-rds-security-group"
  }
}

module "db" {
  source                                = "terraform-aws-modules/rds/aws"
  version                               = "6.1.1"
  identifier                            = "${var.environment}-${var.instance_name}"
  engine                                = var.engine
  engine_version                        = var.engine_version
  family                                = var.family
  major_engine_version                  = var.major_engine_version
  instance_class                        = var.instance_class
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_type                          = var.storage_type
  storage_encrypted                     = var.storage_encrypted
  kms_key_id                            = var.kms_key_id
  db_name                               = var.db_name
  username                              = var.rds_user
  password                              = var.rds_password
  create_db_subnet_group                = true
  port                                  = var.port
  multi_az                              = var.is_multi_az
  iops                                  = var.iops
  subnet_ids                            = var.subnet_ids
  vpc_security_group_ids                = [module.rds_security_group.security_group_id]
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_log_exports
  backup_retention_period               = var.backup_retention_period
  skip_final_snapshot                   = var.skip_final_snapshot
  deletion_protection                   = var.deletion_protection
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitor_interval
  publicly_accessible                   = var.publicly_accessible
  apply_immediately                     = var.apply_immediately
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  delete_automated_backups              = var.delete_automated_backups
  parameter_group_name                  = var.parameter_group_name
  parameters                            = var.parameters

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.instance_name}-rds-instance"
    }
  )

}