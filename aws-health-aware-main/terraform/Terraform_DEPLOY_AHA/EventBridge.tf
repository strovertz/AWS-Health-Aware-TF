
# EventBridge - Schedule to run lambda
resource "aws_cloudwatch_event_rule" "AHA-LambdaSchedule-PrimaryRegion" {
    description         = "Lambda trigger Event"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "AHA-LambdaSchedule-${random_string.resource_code.result}"
    schedule_expression = "rate(1 minute)"
    tags             = {
        "Name"             = "AHA-LambdaSchedule"
    }
}
resource "aws_cloudwatch_event_rule" "AHA-LambdaSchedule-SecondaryRegion" {
    count               = "${var.aha_secondary_region == "" ? 0 : 1}"
    provider            = aws.secondary_region    
    description         = "Lambda trigger Event"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "AHA-LambdaSchedule-${random_string.resource_code.result}"
    schedule_expression = "rate(1 minute)"
    tags             = {
        "Name"             = "AHA-LambdaSchedule"
    }
}

resource "aws_cloudwatch_event_target" "AHA-LambdaFunction-PrimaryRegion" {
    arn            = aws_lambda_function.AHA-LambdaFunction-PrimaryRegion.arn
    rule           = aws_cloudwatch_event_rule.AHA-LambdaSchedule-PrimaryRegion.name
}
resource "aws_cloudwatch_event_target" "AHA-LambdaFunction-SecondaryRegion" {
    count          = "${var.aha_secondary_region == "" ? 0 : 1}"
    provider       = aws.secondary_region    
    arn            = aws_lambda_function.AHA-LambdaFunction-SecondaryRegion[0].arn
    rule           = aws_cloudwatch_event_rule.AHA-LambdaSchedule-SecondaryRegion[0].name
}

resource "aws_lambda_permission" "AHA-LambdaSchedulePermission-PrimaryRegion" {
    action        = "lambda:InvokeFunction"
    principal     = "events.amazonaws.com"
    function_name = aws_lambda_function.AHA-LambdaFunction-PrimaryRegion.arn
    source_arn    = aws_cloudwatch_event_rule.AHA-LambdaSchedule-PrimaryRegion.arn
}
resource "aws_lambda_permission" "AHA-LambdaSchedulePermission-SecondaryRegion" {
    count         = "${var.aha_secondary_region == "" ? 0 : 1}"
    provider      = aws.secondary_region    
    action        = "lambda:InvokeFunction"
    principal     = "events.amazonaws.com"
    function_name = aws_lambda_function.AHA-LambdaFunction-SecondaryRegion[0].arn
    source_arn    = aws_cloudwatch_event_rule.AHA-LambdaSchedule-SecondaryRegion[0].arn
}

