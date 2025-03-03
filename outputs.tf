output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "The base64 encoded certificate data required to communicate with your cluster"
  value = module.eks.cluster_certificate_authority
  sensitive = true
}

output "eks_cluster_token" {
  description = "The token required to communicate with your cluster"
  value = module.eks.cluster_token
  sensitive = true
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "clickhouse_cluster_password" {
  description = "The generated password for the ClickHouse cluster"
  value       = module.clickhouse_cluster.clickhouse_cluster_password
  sensitive   = true
}

# output "clickhouse_cluster_url" {
#   description = "The public URL for the ClickHouse cluster"
#   value       = module.clickhouse_cluster.clickhouse_cluster_url
# }
