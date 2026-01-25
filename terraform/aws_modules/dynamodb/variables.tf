variable "table_name" {
  description = "Dynamo db table name"
  type = string
}

variable "region" {
    description = "Cluster region"
    type = string
    default = "us-east-2"
  
}

variable "billing_mode" {
    description = "Billing mode for Dynamo db"
    type = string
    default = "PAY_PER_REQUEST"
  
}

variable "hash_key" {
  description = "Hash key for db table"
  type = string
  default = "object_key"
}