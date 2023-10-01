variable "additional_ingress_rule" {
  description = "List of ingress rules to create where cidr_blocks is used"
  type        = list(any)
  default     = []
}

variable "ingress_cidrs" {
  description = "Map of Port to CIDR access"
  type        = map(any)
  default = {
    ssh_port     = []
    jenkins_port = []
  }
}

variable "instance_type" {
  description = "Jenkins Instance type "
  default     = "t2.micro"
}

variable "instance_ami_id" {
  description = "Ami ID for Jenkins Instance"
  default     = "ami-05ba3a39a75be1ec4"
  type        = string
}

variable "vpc_sg_id" {
  description = "Security group ids for instance"
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  description = "VPC id for instance Security group"
  type        = string
}

variable "subnet_id" {
  description = "subnet ids for jenkins instance"
  type        = string
}

variable "ebs_block_device" {
  description = "jenkins ebs block storage conf"
  type        = list(any)
  default = [{
    device_name           = "/dev/sdf"
    volume_type           = "gp3"
    volume_size           = 20
    iops                  = 3000
    throughput            = 125
    encrypted             = false
    delete_on_termination = true
  }]
}

variable "root_block_device" {
  description = "jenkins root block storage conf"
  type        = list(any)
  default = [{
    device_name           = "/dev/xvda"
    volume_type           = "gp3"
    volume_size           = 10
    iops                  = 3000
    throughput            = 125
    encrypted             = false
    delete_on_termination = true
  }]
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "environment" {
  default = "demo"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
}

variable "name" {
  description = "jenkins Instance Name"
  default     = "Jenkins Master"
}

variable "user_data" {
  description = "Commands to run after launching instance "
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
}

variable "tags" {
  description = "attach tags to your instance"
  default = {
    purpose  = "jenkins"
    dept     = "devops"
    sub-dept = "cicd"
  }
}
