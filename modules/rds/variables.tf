variable "environment" {}
variable "tags" {}
variable "vpc_id" {
  description = "VPC for RDS Security Group"
  type        = string
  default     = ""
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where cidr_blocks is used"
  type        = list(map(string))
  default     = []
}

variable "performance_insights_enabled" {
  description = "Flag to check whether Performance Insights are enabled or not"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Subnets Ids for RDS"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Deletion protection for RDS"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Retention period of performance Insights"
  type        = number
  default     = 7
}

variable "instance_name" {
  description = "Name of the RDS instance"
  default     = ""
}

variable "allocated_storage" {
  description = "Integer with the number of GB to allocate"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Integer with the Max number of GB to allocate"
  type        = number
  default     = 1000
}

variable "engine" {
  description = "RDS DB engine"
  type        = string
  default     = "postgres"
}

variable "family" {
  description = "DB Family"
  type        = string
  default     = "postgres14"
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
  default     = "14.7"
}

variable "major_engine_version" {
  description = "Major DB engine version"
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "Instance class to launch the database on"
  type        = string
  default     = ""
}

variable "storage_type" {
  description = "'gp2' for general purpose SSD or 'io1' for provisined IOPS SSD. Automatically defaults to io1 if `iops` variable is specified"
  type        = string
  default     = "gp2"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = 0
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "app_db"
}

variable "rds_user" {
  description = "Database username"
  type        = string
  default     = ""
  sensitive   = true
}

variable "rds_password" {
  description = "Database password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "port" {
  description = "RDS Port"
  type        = string
  default     = "5432"
}

variable "skip_final_snapshot" {
  description = "Skip the creation of the final database snapshot on destroy"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Whether Staorage is encrypted or not"
  type        = bool
  default     = false
}

variable "is_multi_az" {
  description = "Multi Availability Zone"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Maintenance window time"
  type        = string
  default     = "Sun:00:00-Sun:13:00"
}

variable "backup_retention_period" {
  description = "Number of days to keep backups"
  type        = number
  default     = 30
}

variable "backup_window" {
  description = "Backup window timeframe"
  type        = string
  default     = "13:00-16:00"
}

variable "publicly_accessible" {
  description = "Whether Publicly Accessible"
  type        = bool
  default     = false
}

variable "create_monitoring_role" {
  description = "Whether to create Montioring Role"
  type        = bool
  default     = false
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "	The ARN for the KMS encryption key. "
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group "
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "A list of DB parameters to apply"
  type        = list(map(string))
  default     = []
}

variable "monitor_interval" {
  description = "Monito Interval Count"
  type        = number
  default     = 0
}

variable "enabled" {
  description = "Enable this resource"
  default     = true
}

variable "enabled_cloudwatch_log_exports" {
  description = "enabled cloudwatch log exports"
  default     = ["postgresql", "upgrade"]
}

variable "allow_major_version_upgrade" {
  default     = false
  description = "Allow Major version upgrade"
  type        = bool
}

variable "allow_minor_version_upgrade" {
  default     = true
  description = "Allow Minor version upgrade"
  type        = bool
}

variable "route53_zone_id" {
  description = "Route53 zone ID to set up the DNS entry"
  type        = string
  default     = ""
}

variable "fqdn" {
  description = "fqdn to setup a DNS record"
  type        = string
  default     = ""
}

variable "db_secret_name" {
  description = "db secret name"
  type        = string
  default     = "db-secret"
}
