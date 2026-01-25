variable "bucket_name" {
  description = "Bucket name"
  type = string
}

# variable "bucket_prefix" {
#     description = "Bucket prefix"
#     type = string
  
# }

variable "bucket_key" {
    description = "Name/path of object"
    type = string
  
}

variable "region" {
  description = "Bucket region"
  type = string
  default = "us-east-2"
}

variable "force_destroy" {
  description = "Force destroy option"
  type = string
  default = false
}

variable "bucket_rule_id" {
  description = "bucket lifecyle rule id"
  type = string
}

variable "bucket_rule_status" {
  description = "Bucket rule status Enabled or Disabled"
  type = string
  default = "Enabled"
}

variable "bucket_exp_days" {
  description = "Number of days till a bucket object gets deleted"
  type = number
  default = 60
}

variable "versioning_config_status" {
  description = "Bucket version config status Enabled, Suspended, or Disabled. Disabled"
  type = string
  default = "Enabled"
}

variable "s3_server_sse_algorithm" {
  description = " Server side encryption options AES256, aws:kms, and aws:kms:dsse"
  type = string
  default = "AES256"
}