

module "customer-stack" {
  source                    = "iomete/customer-stack/aws"
  version                   = "1.3.0"
  region                    = "us-east-1"  
  cluster_id                = "kgnwqy"  

  # the followings are your lakehouse bucket name and role name to access it
	lakehouse_role_name 		  = "iomete-lakehouse-role-kgnwqy"
	lakehouse_bucket_name     = "iomete-lakehouse-bucket-kgnwqy"
 
  #optional | additional_administrators = ["arn:aws:iam::1234567890:user/your_arn", "arn:aws:iam::1234567890:user/user2", "arn:aws:iam::1234567890:user/user3"] # list of IAM users or roles that can administer the KMS key and Kubernetes
}
################# 
# Outputs 
#################

output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = module.customer-stack.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.customer-stack.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate cluster with the IOMETE controlplane"
  value       = module.customer-stack.cluster_certificate_authority_data
}




