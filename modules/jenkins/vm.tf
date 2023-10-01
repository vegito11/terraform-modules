module "jenkins_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-server-sg"
  description = "Allow SSH and HTTP Access to Jenkins Server"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = concat([
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = "Allow SSH "
      cidr_blocks = join(",", var.ingress_cidrs["ssh_port"])
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "TCP"
      description = "Allow Access to Jenkins Port"
      cidr_blocks = join(",", var.ingress_cidrs["jenkins_port"])
    },
  ], var.additional_ingress_rule)
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags
}


resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-${var.environment}_profile"
  role = aws_iam_role.jenkins_instance_role.name
}

module "jenkins_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                        = var.name
  instance_type               = var.instance_type
  ami                         = var.instance_ami_id
  key_name                    = var.key_name
  vpc_security_group_ids      = concat([module.jenkins_server_sg.security_group_id], var.vpc_sg_id)
  subnet_id                   = var.subnet_id
  private_ip                  = var.private_ip
  user_data                   = var.user_data
  disable_api_termination     = var.disable_api_termination
  ebs_block_device            = var.ebs_block_device
  root_block_device           = var.root_block_device
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.jenkins_instance_profile.name

  tags = merge({
    owner       = "terraform"
    environment = "${var.environment}"
  }, var.tags)
}

output "jenkins_public_ip" {
  value      = module.jenkins_instance.public_ip
  depends_on = [module.jenkins_instance]
}

output "jenkins_private_ip" {
  value      = module.jenkins_instance.private_ip
  depends_on = [module.jenkins_instance]
}

output "id" {
  value      = module.jenkins_instance.id
  depends_on = [module.jenkins_instance]
}
