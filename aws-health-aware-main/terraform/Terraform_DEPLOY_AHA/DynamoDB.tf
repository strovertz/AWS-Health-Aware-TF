
# DynamoDB table - Multi region Global Table - Create if secondary region is set
resource "aws_dynamodb_table" "AHA-GlobalDynamoDBTable" {
    count = "${var.aha_secondary_region == "" ? 0 : 1}"
    billing_mode     = "PAY_PER_REQUEST"
    hash_key         = "arn"
    name             = "${var.dynamodbtable}-${random_string.resource_code.result}"
    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
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

    replica {
        region_name = var.aha_secondary_region
    }

    timeouts {}

    ttl {
        attribute_name = "ttl"
        enabled        = true
    }
}
# Tags for DynamoDB - secondary region
resource "aws_dynamodb_tag" "AHA-GlobalDynamoDBTable" {
    count = "${var.aha_secondary_region == "" ? 0 : 1}"
    provider   = aws.secondary_region
    resource_arn = replace(aws_dynamodb_table.AHA-GlobalDynamoDBTable[count.index].arn, var.aha_primary_region, var.aha_secondary_region)
    key          = "Name"
    value        = "${var.dynamodbtable}"
}
# Tags for DynamoDB - secondary region - default_tags
resource "aws_dynamodb_tag" "AHA-GlobalDynamoDBTable-Additional-tags" {
    for_each = { for key, value in var.default_tags : key => value if var.aha_secondary_region != "" }
    provider   = aws.secondary_region
    resource_arn = replace(aws_dynamodb_table.AHA-GlobalDynamoDBTable[0].arn, var.aha_primary_region, var.aha_secondary_region)
    key          = each.key
    value        = each.value
}
