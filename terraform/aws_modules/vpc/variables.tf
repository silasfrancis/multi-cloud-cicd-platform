variable "region" {
    description = "Default region for provider"
    type = string
    default = "us-east-2"
}

variable "vpc_tag" {
    description = "Cluster name"
    type = string 
  
}