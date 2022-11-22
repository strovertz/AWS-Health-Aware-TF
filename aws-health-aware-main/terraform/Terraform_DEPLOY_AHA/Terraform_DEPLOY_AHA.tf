# Terraform script to deploy AHA Solution
# 1.0 - Initial version 

# Variables defined below, you can overwrite them using tfvars or imput variables

data "aws_caller_identity" "current" {}

provider "aws" {
    region  = var.aha_primary_region
    default_tags {
      tags = "${var.default_tags}"
    }
}

# Secondary region - provider config
locals {
    secondary_region = "${var.aha_secondary_region == "" ? var.aha_primary_region : var.aha_secondary_region}"
}

provider "aws" {
    alias   = "secondary_region"
    region  = local.secondary_region
    default_tags {
      tags = "${var.default_tags}"
    }
}

# Comment below - if needed to use s3_bucket, s3_key for consistency with cf 
locals {
    source_files = ["../../handler.py", "../../messagegenerator.py"]
}
data "template_file" "t_file" {
    count = "${length(local.source_files)}"
    template = "${file(element(local.source_files, count.index))}"
}
data "archive_file" "lambda_zip" {
    type          = "zip"
    output_path   = "lambda_function.zip"
    source {
      filename = "${basename(local.source_files[0])}"
      content  = "${data.template_file.t_file.0.rendered}"
    }
    source {
      filename = "${basename(local.source_files[1])}"
      content  = "${data.template_file.t_file.1.rendered}"
  }
}

##### Resources for AHA Solution created below.

# Random id generator
resource "random_string" "resource_code" {
  length  = 8
  special = false
  upper   = false
}