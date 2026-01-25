terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

data "aws_iam_role" "cluster_role" {
    name = "AmazonEKSAutoClusterRole"
}

data "aws_iam_role" "node_role" {
    name = "AmazonEKSAutoNodeRole"
}