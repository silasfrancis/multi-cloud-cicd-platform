terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

resource "aws_dynamodb_table" "dynamo_table_for_s3" {
    name = var.table_name
    region = var.region
    billing_mode = var.billing_mode
    hash_key = var.hash_key
    attribute {
      name = var.hash_key
      type = "S"
    }
  
}