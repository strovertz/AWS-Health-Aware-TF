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

# DynamoDB table - Create if secondary region not set
resource "aws_dynamodb_table" "AHA-DynamoDBTable" {
    count = "${var.aha_secondary_region == "" ? 1 : 0}"
    billing_mode   = "PROVISIONED"
    hash_key       = "arn"
    name           = "${var.dynamodbtable}-${random_string.resource_code.result}"
    read_capacity  = 5
    write_capacity = 5
    stream_enabled = false
    tags           = {
       Name   = "${var.dynamodbtable}"
    }

    attribute {
        name = "arn"
        type = "S"
    }

    point_in_time_recovery {
        enabled = false
    }

    timeouts {}

    ttl {
        attribute_name = "ttl"
        enabled        = true
    }
}
