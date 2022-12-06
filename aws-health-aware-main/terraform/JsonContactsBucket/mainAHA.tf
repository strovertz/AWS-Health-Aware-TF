# Terraform script to deploy AHA Solution
# 1.0 - Initial version 

# Variables defined below, you can overwrite them using tfvars or imput variables

provider "aws" {
    region  = "${var.region}"
    default_tags {
      tags = "${var.default_tags}"
    }
}

# Random id generator
resource "random_string" "resource_code" {
  length  = 8
  special = false
  upper   = false
}