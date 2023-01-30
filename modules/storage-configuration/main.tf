provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
    "iomete.com/managed" : true
    "iomete.com/terraform" : true
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.lakehouse_bucket_name
  tags = local.tags
}
 

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = var.lakehouse_bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Create IAM role and policy for new workspace
resource "aws_iam_role_policy" "this" {
  name = "${var.lakehouse_bucket_name}-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
        ]
        Resource = "arn:aws:s3:::${var.lakehouse_bucket_name}/*"
      },
      {

        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.lakehouse_bucket_name}"
      }
    ]
  })
}


resource "aws_iam_role" "this" {
  name = var.lakehouse_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.cluster_role_arn
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = local.tags
}