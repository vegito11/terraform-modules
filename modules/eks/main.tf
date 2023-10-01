locals {
  account_id = data.aws_caller_identity.current.account_id
}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

/*## required for aws-auth updates
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
*/


resource "aws_iam_policy" "workers_default_policy" {
  name        = "${var.cluster_name}-k8s-worker-default-policy"
  description = "This policy is used by worker nodes default IAM Role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "LeastAccess",
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags",
        ],
        "Resource" : "*"
      }
    ]
  })
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
  cluster_addons            = var.cluster_addons

  vpc_id                                = var.vpc_id
  subnet_ids                            = var.subnet_ids
  cluster_additional_security_group_ids = var.cluster_additional_security_group_ids
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs

  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  node_security_group_id               = var.node_security_group_id
  node_security_group_name             = var.node_security_group_name
  node_security_group_additional_rules = var.node_security_group_additional_rules

  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  enable_irsa  = var.enable_irsa
  iam_role_arn = var.iam_role_arn

  eks_managed_node_group_defaults = {
    name_prefix = "${var.environment}-eks-"
    version     = var.cluster_version
    subnet_ids  = var.worker_subnet_ids
    tags = merge(
      var.tags,
      {
        Name = "${var.environment}-eks-node-group"
      },
    )
    iam_role_additional_policies = {
      ecr_read   = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      worker_ecr = "arn:aws:iam::${local.account_id}:policy/${aws_iam_policy.workers_default_policy.name}"

    }
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-eks-cluster"
    },
  )

}

