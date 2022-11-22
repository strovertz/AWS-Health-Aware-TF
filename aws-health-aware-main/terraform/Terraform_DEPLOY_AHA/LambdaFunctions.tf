# aws_lambda_function - AHA-LambdaFunction - Primary region
resource "aws_lambda_function" "AHA-LambdaFunction-PrimaryRegion" {
    description                    = "Lambda function that runs AHA"
    function_name                  = "AHA-LambdaFunction-${random_string.resource_code.result}"
    handler                        = "handler.main"
    memory_size                    = 128
    timeout                        = 600
    filename                       = data.archive_file.lambda_zip.output_path
    source_code_hash               = filebase64sha256(data.archive_file.lambda_zip.output_path)
#    s3_bucket                      = var.S3Bucket
#    s3_key                         = var.S3Key
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.AHA-LambdaExecutionRole.arn
    runtime                        = "python3.8"

    environment {
        variables = {
            "DYNAMODB_TABLE"      = "${var.dynamodbtable}-${random_string.resource_code.result}"
            "EMAIL_SUBJECT"       = var.Subject
            "EVENT_SEARCH_BACK"   = var.EventSearchBack
            "FROM_EMAIL"          = var.FromEmail
            "HEALTH_EVENT_TYPE"   = var.AWSHealthEventType
            "ORG_STATUS"          = var.AWSOrganizationsEnabled
            "REGIONS"             = var.Regions
            "TO_EMAIL"            = var.ToEmail
            "MANAGEMENT_ROLE_ARN" = var.ManagementAccountRoleArn
            "ACCOUNT_IDS"         = var.ExcludeAccountIDs
            "S3_BUCKET"           = join("",aws_s3_bucket.AHA-S3Bucket-PrimaryRegion[*].bucket)
        }
    }

    timeouts {}

    tracing_config {
        mode = "PassThrough"
    }
    tags             = {   
        "Name"             = "AHA-LambdaFunction"
    }
    depends_on = [
      aws_dynamodb_table.AHA-DynamoDBTable,
      aws_dynamodb_table.AHA-GlobalDynamoDBTable,
    ]
}

# aws_lambda_function - AHA-LambdaFunction - Secondary region
resource "aws_lambda_function" "AHA-LambdaFunction-SecondaryRegion" {
    count                          = "${var.aha_secondary_region == "" ? 0 : 1}"
    provider                       = aws.secondary_region
    description                    = "Lambda function that runs AHA"
    function_name                  = "AHA-LambdaFunction-${random_string.resource_code.result}"
    handler                        = "handler.main"
    memory_size                    = 128
    timeout                        = 600
    filename                       = data.archive_file.lambda_zip.output_path
    source_code_hash               = filebase64sha256(data.archive_file.lambda_zip.output_path)
#    s3_bucket                      = var.S3Bucket
#    s3_key                         = var.S3Key
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.AHA-LambdaExecutionRole.arn
    runtime                        = "python3.8"

    environment {
        variables = {
            "DYNAMODB_TABLE"      = "${var.dynamodbtable}-${random_string.resource_code.result}"
            "EMAIL_SUBJECT"       = var.Subject
            "EVENT_SEARCH_BACK"   = var.EventSearchBack
            "FROM_EMAIL"          = var.FromEmail
            "HEALTH_EVENT_TYPE"   = var.AWSHealthEventType
            "ORG_STATUS"          = var.AWSOrganizationsEnabled
            "REGIONS"             = var.Regions
            "TO_EMAIL"            = var.ToEmail
            "MANAGEMENT_ROLE_ARN" = var.ManagementAccountRoleArn
            "ACCOUNT_IDS"         = var.ExcludeAccountIDs
            "S3_BUCKET"           = join("",aws_s3_bucket.AHA-S3Bucket-SecondaryRegion[*].bucket)
        }
    }

    timeouts {}

    tracing_config {
        mode = "PassThrough"
    }
    tags             = {
        "Name"             = "AHA-LambdaFunction"
    }
    depends_on = [
      aws_dynamodb_table.AHA-DynamoDBTable,
      aws_dynamodb_table.AHA-GlobalDynamoDBTable,
    ]
}