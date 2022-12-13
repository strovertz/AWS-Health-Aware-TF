# S3 buckets creation
resource "aws_s3_bucket" "AHA-S3Bucket-PrimaryRegion" {
    count      = "${var.ExcludeAccountIDs != "" ? 1 : 0}"
    bucket     = "aha-bucket-${var.aha_primary_region}-${random_string.resource_code.result}"
    tags = {
      Name        = "aha-bucket"
    }
}

resource "aws_s3_bucket_acl" "AHA-S3Bucket-PrimaryRegion" {
    bucket = aws_s3_bucket.AHA-S3Bucket-PrimaryRegion[0].id
    acl    = "private"
}

resource "aws_s3_bucket" "AHA-S3Bucket-SecondaryRegion" {
    count      = "${var.aha_secondary_region != "" && var.ExcludeAccountIDs != "" ? 1 : 0}"
    provider   = aws.secondary_region
    bucket     = "aha-bucket-${var.aha_secondary_region}-${random_string.resource_code.result}"
    tags = {
      Name        = "aha-bucket"
    }
}

resource "aws_s3_bucket_acl" "AHA-S3Bucket-SecondaryRegion" {
    count  = "${var.aha_secondary_region != "" && var.ExcludeAccountIDs != "" ? 1 : 0}"
    provider   = aws.secondary_region
    bucket = aws_s3_bucket.AHA-S3Bucket-SecondaryRegion[0].id
    acl    = "private"
}

resource "aws_s3_object" "AHA-S3Object-PrimaryRegion" {
    count      = "${var.ExcludeAccountIDs != "" ? 1 : 0}"
    key        = var.ExcludeAccountIDs
    bucket     = aws_s3_bucket.AHA-S3Bucket-PrimaryRegion[0].bucket
    source     = var.ExcludeAccountIDs
    tags = {
      Name        = "${var.ExcludeAccountIDs}"
    }
}

resource "aws_s3_object" "AHA-S3Object-SecondaryRegion" {
    count      = "${var.aha_secondary_region != "" && var.ExcludeAccountIDs != "" ? 1 : 0}"
    provider   = aws.secondary_region
    key        = var.ExcludeAccountIDs
    bucket     = aws_s3_bucket.AHA-S3Bucket-SecondaryRegion[0].bucket
    source     = var.ExcludeAccountIDs
    tags = {
      Name        = "${var.ExcludeAccountIDs}"
    }
}

resource "aws_s3_bucket" "contactsaha" {
  bucket = "aha-contacts-bucket-${var.aha_primary_region}-${random_string.resource_code.result}"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "AHA Contacts Bucket"
  }
}

resource "aws_s3_bucket_acl" "contactscl" {
  bucket = aws_s3_bucket.contactsaha.id
  acl    = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket       = aws_s3_bucket.contactsaha.bucket
  key          = "config/contacts"
  source       = "data/mail_list.json"
# Dados para aplicacao de arquivo no bucket
  tags = local.common_tags
}