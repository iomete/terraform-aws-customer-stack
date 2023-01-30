provider "aws" {
  region = var.region
}

locals {
  cluster_name   = "iomete-${var.cluster_id}"
  module_version = "1.0.0"

  tags = {
    "iomete.com/cluster_id" : var.cluster_id
    "iomete.com/cluster_name" : local.cluster_name
    "iomete.com/terraform" : true
    "iomete.com/managed" : true
  }
}

module "storage-configuration" {
  source                = "./modules/storage-configuration"
  aws_region            = var.region
  lakehouse_bucket_name = var.lakehouse_bucket_name
  lakehouse_role_name   = var.lakehouse_role_name
  cluster_role_arn      = aws_iam_role.cluster_lakehouse.arn
}
