output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_token" {
  value     = data.aws_eks_cluster_auth.cluster.token
  sensitive = true
}

output "cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

output "worker_iam_role_policy" {
  value = aws_iam_policy.workers_default_policy.name
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

/*output "managed_worker_node_data"{
  value = module.eks.eks_managed_node_groups
}
*/

output "worker_iam_role_names" {
  value = [for grp_name, grp_data in module.eks.eks_managed_node_groups : grp_data["iam_role_name"]]
}