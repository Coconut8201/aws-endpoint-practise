variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
}

variable "vpc_endpoint_id" {
  description = "VPC Endpoint ID for S3"
  type        = string
  default     = null
}

variable "admin_principal_arn" {
  description = "Admin IAM principal ARN to exclude from deny policy"
  type        = string
}
