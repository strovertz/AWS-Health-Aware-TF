variable "bucket_name" {}

variable "acl_value" {

    default = "aha-jsoncontacts"

variable "aws_region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = ""
  default     = "default"
}

variable "environment" {
  type        = string
  description = ""
  default     = "Interno"
}

variable "s3_tags" {
  type        = map(string)
  description = ""
  default = {
    Criado    =  "data"
    Project   = "AHA"
    ManagedBy = "Terraform"
  }
}
}