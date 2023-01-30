output "bucket_arn" {
  description = "An s3 bucket name to be created. Lakehouse data will be stored in this bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_access_role_arn" {
  description = "A role to access to the the bucket."
  value       = aws_iam_role.this.arn
}

