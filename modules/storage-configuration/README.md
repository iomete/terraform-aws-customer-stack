# IOMETE Customer-Stack, Storage configuration mmodule

## Terraform module which creates S3 bucket and IAM role for new workspace.

## Usage example
 
```hcl

module "storage-configuration-[workspace-name]" {
  source                     = "iomete/customer-stack/aws//modules/storage-configuration"
  version                    = "1.3.0"
  aws_region                 = "us-east-1" # Cluster installed region 
  lakehouse_role_name 	     = "iomete-lakehouse-role-kgnwqy" 
  lakehouse_bucket_name      = "iomete-lakehouse-bucket-kgnwqy"
  cluster_lakehouse_role_arn = aws_iam_role.cluster_lakehouse.arn  
}

```

## Description of variables

| Name | Description | Required |
| --- | --- | --- |
| aws_region | AWS region where cluster is deployed | yes |
| lakehouse_bucket_name | Name of the bucket must be unique across all existing bucket names in AWS | yes |
| lakehouse_role_name | New role for access to the new bucket | yes |
| cluster_lakehouse_role_arn | Name of existing cluster lakehouse role ARN where the new role will have AssumeRole trust. | yes |

