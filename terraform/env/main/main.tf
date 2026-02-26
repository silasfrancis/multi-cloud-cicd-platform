terraform {
  backend "s3" {
    bucket = "k8-main-cluster-silas-main"
    key = "main/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = ""
    encrypt = true
    
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
 region = "us-east-2"
}

locals {
  environment = "main"
  cluster_name = "k8-main-cluster"
}

module "vpc" {
    source = "../../aws_modules/vpc"

    vpc_tag = local.cluster_name
}

module "iam" {
    source = "../../aws_modules/iam"
  
}

module "eks" {
  source = "../../aws_modules/eks"

  cluster_name = local.cluster_name
  k8_version = "1.34"
  cluster_role_arn = module.iam.role_arn["cluster_role_arn"]
  node_role_arn = module.iam.role_arn["node_role_arn"]
  subnet_ids_for_cluster = [
                            module.vpc.subnet_ids_for_cluster["primary_subnet_id"],
                            module.vpc.subnet_ids_for_cluster["secondary_subnet_id"]
                            ]
  subnet_ids_node_group = module.vpc.subnet_ids_for_node_group
  node_scaling_config = {
                            desired_size = 2
                            max_size = 2
                            min_size = 1
                        }
  security_group_id = ["module.vpc.security_group_id"]
  ami_type = "AL2_x86_64"
  disk_size = "20"
  instance_types = ["m7i-flex.large"]

    depends_on = [
    module.vpc,
    module.iam
  ]

}

module "iam_aws_lb_controller_k8" {
  source = "../../aws_modules/iam_aws_lb_controller_k8"

  eks_cluster_oidc_issuer = module.eks.eks_cluster_oidc_issuer
  service_account_name = "aws-load-balancer-controller"
  service_account_namespace = "kube-system"
}

module "ecr" {
    source = "../../aws_modules/ecr"
  
}
module "s3" {
    source = "../../aws_modules/s3"
  
  bucket_name = "${local.cluster_name}-silas-${local.environment}"
  bucket_key = "${local.environment}/terraform.tfstate"
  bucket_rule_id = "${local.cluster_name}${local.environment}"
  bucket_rule_status = "Enabled"
  bucket_exp_days = 60
  versioning_config_status = "Enabled"
  s3_server_sse_algorithm = "AES256"
}

module "dynamodb" {
  source = "../../aws_modules/dynamodb"

  table_name = "${local.environment}db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "object_key"
}