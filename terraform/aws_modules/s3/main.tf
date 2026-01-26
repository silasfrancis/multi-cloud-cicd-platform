terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  region = var.region
#   bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy
  tags = {
    Name = "trfbackend"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_config" {
    bucket = aws_s3_bucket.s3_bucket.id
    rule {
      id = var.bucket_rule_id
      status = var.bucket_rule_status
      expiration {
        days = var.bucket_exp_days
      }
    }
  
}

resource "aws_s3_object" "s3_object" {
  bucket = var.bucket_name
  key = var.bucket_key
  region = var.region

  depends_on = [ aws_s3_bucket.s3_bucket ]
}

resource "aws_s3_bucket_versioning" "bucket_versioning_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning_config_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_server_side_config" {
    bucket = aws_s3_bucket.s3_bucket.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = var.s3_server_sse_algorithm
        }
    }  
}