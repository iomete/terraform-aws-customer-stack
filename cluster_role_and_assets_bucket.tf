locals {
  cluster_role               = "${local.cluster_name}-role"
  cluster_assets_bucket_name = "${local.cluster_name}-assets"
}



################################################################################
# Cluster IAM Role
################################################################################

resource "aws_iam_role_policy" "cluster_lakehouse" {
  name = "${local.cluster_role}-policy"
  role = aws_iam_role.cluster_lakehouse.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "cluster_lakehouse-s3-access" {
  name = "${local.cluster_role}-s3-access-policy"
  role = aws_iam_role.cluster_lakehouse.id

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
        Resource = "arn:aws:s3:::${local.cluster_assets_bucket_name}/*"
      },
      {

        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${local.cluster_assets_bucket_name}"
      },
    ]
  })
}

resource "aws_iam_role" "cluster_lakehouse" {
  name = local.cluster_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "${module.eks.oidc_provider}:sub" : [
              "system:serviceaccount:workspace-*:spark-service-account",
              "system:serviceaccount:iomete-system:*",
              "system:serviceaccount:monitoring:loki-s3access-sa"
            ]
          },
          StringEquals = {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })
  tags = local.tags
}


################################################################################
# Cluster Assets Bucket
################################################################################

resource "aws_s3_bucket" "assets" {
  bucket = local.cluster_assets_bucket_name

  tags = local.tags

}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = local.cluster_assets_bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "assets" {
  bucket = local.cluster_assets_bucket_name

  rule {
    id = "retention-rule"
    expiration {
      days = 180
    }
    status = "Enabled"
  }

  depends_on = [
    aws_s3_bucket.assets
  ]
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket_lifecycle_configuration.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}