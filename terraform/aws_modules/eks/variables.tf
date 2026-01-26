variable "cluster_name" {
  description = "EKS Cluster name"
  type = string
}

variable "region" {
    description = "Cluster region"
    type = string
    default = "us-east-2"
  
}

variable "k8_version" {
    description = "k8 version"
    type = string
    default = "1.34"
  
}

variable "cluster_role_arn" {
  description = "Cluster role arn"
  type = string
}

variable "node_role_arn" {
  description = "Node role arn"
  type = string
}

variable "subnet_ids_for_cluster" {
  description = "Vpc subnet ids"
  type = list(string)
}

variable "subnet_ids_node_group" {
  description = "Vpc subnet ids"
  type = list(string)
}

variable "node_scaling_config" {
    description = "Number of nodes in the cluster and optional scale config"
    type = object({
      desired_size = number
      max_size = number
      min_size = number
    })
  
}

variable "security_group_id" {
    description = "Security group id"
    type = list(string)
  
}

variable "ami_type" {
    description = "AMI type"
    type = string
  
}

variable "disk_size" {
    description = "Node disk size"
    type = string
  
}

variable "instance_types" {
    description = "Instance type of node"
    type = list(string)
  
}