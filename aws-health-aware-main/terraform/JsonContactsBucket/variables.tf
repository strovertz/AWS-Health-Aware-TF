variable "bucket_name" {
    type = "string"
    default = "aha-jsoncontatcs"
}

variable "acl_value" {

    default = "private"

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