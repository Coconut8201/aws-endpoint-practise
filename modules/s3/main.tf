resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

# S3 Bucket Policy - Only allow access from VPC Endpoint
resource "aws_s3_bucket_policy" "this" {
  count  = var.vpc_endpoint_id != null ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAccessFromVPCEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.s3.arn,
          "${aws_s3_bucket.s3.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = var.vpc_endpoint_id
          }
        }
      },
      {
        Sid       = "DenyAccessFromNonVPCEndpoint"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.s3.arn,
          "${aws_s3_bucket.s3.arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = var.vpc_endpoint_id
          }
          ArnNotLike = {
            "aws:PrincipalArn" = var.admin_principal_arn
          }
        }
      }
    ]
  })
}
