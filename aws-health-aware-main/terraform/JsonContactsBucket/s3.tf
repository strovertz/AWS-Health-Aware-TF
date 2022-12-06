module "s3" {

    source = "<path-to-S3-folder>"

    bucket_name = "your_bucket_name"       

}

resource "random_pet" "bucket" {
  length = 5
}


resource "aws_s3_bucket" "temps3" {

    bucket = "${var.bucket_name}-${random_pet.bucket.id}" 

    acl = "${var.acl_value}"   

}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.temps3.bucket
  key          = "config/contacts"
  source       = "./mail_list.json"
# Dados para aplicacao de arquivo no bucket
  tags = local.common_tags
}