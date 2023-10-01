variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "environment" {
  description = "The Deployment environment"
}


variable "project" {
  type        = string
  description = "Project Name Tag"
  default     = "eximfile"
}

variable "public_subnets" {
  description = "A map of availability zones to public cidrs"
  type        = map(string)
  default = {
    us-east-1a = "",
    us-east-1b = ""
  }
}

variable "private_subnets" {
  description = "A map of availability zones to private cidrs"
  type        = map(string)
  default = {
    us-east-1a = "",
    us-east-1b = ""
  }
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "eks_cluster_name" {
  description = "A eks cluster name to set subnet specific tags"
  type        = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "nat_enabled" {
  type    = bool
  default = true
}