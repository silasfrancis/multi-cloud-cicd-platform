terraform {
  backend "remote" {
    organization = "silasfrancis"

    workspaces {
      name = "silasfrancis-workspace"
    }
    
  }

  required_providers {
    linode = {
      source = "linode/linode"
      version = "3.8.0"
    }
  }
}

provider "linode" {
}

locals {
  environment = dev
  cluster_name = k8-main-cluster
  region = "us-lax"
}

module "vpc" {
  source = "../../linode_modules/vpc"

  vpc_name = local.cluster_name
  region = local.region
}

module "lke" {
  source = "../../linode_modules/lke"

  cluster_name = local.cluster_name
  k8_version = "1.34"
  region = local.region
  vpc_id = module.vpc.vpc_id
  node_pool_type = "g6-standard-1"
  node_count = 2
}