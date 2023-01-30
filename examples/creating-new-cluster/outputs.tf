################################################################################
# Outputs 
################################################################################

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.customer-stack.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate cluster with the IOMETE controlplane"
  value       = module.customer-stack.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "Kuberenetes cluster name"
  value       = module.customer-stack.cluster_name
}
