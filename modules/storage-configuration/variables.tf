variable "aws_region" {
  description = "AWS region where S3 bucket and role will be created"
  type        = string
}

variable "lakehouse_role_name" {
  description = "A role to access to the lakehouse bucket."
  type        = string
}

variable "lakehouse_bucket_name" {
  description = "A bucket name to store lakehouse data."
  type        = string
}
variable "cluster_role_arn" {
  description = "Cluster lakehouse role arn where the new role will have AssumeRole trust."
  type        = string
}