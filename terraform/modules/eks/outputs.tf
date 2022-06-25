output "eks_endpoint" {
  value = data.aws_eks_cluster.cloud_tech_demo.endpoint
}

output "eks_certificate_authority" {
  value = data.aws_eks_cluster.cloud_tech_demo.certificate_authority[0].data
}

output "eks_auth_token" {
  value = data.aws_eks_cluster_auth.cloud_tech_demo.token
}
