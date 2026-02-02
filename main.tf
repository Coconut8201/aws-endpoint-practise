# VPC settings
module "coco-endpoint-vpc" {
  source = "./modules/vpc"

  vpc_name          = var.vpc_name
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidrs_block
  az                = var.az
  region            = var.region

  tags = {
    Name = var.vpc_name
  }
}

# S3 bucket
module "coco-endpoint-s3" {
  source = "./modules/s3"

  bucket_name         = var.bucket_name
  vpc_endpoint_id     = module.coco-endpoint-vpc.s3_endpoint_id
  admin_principal_arn = var.admin_principal_arn
}
