
variable "aha_primary_region" {
    description = "Primary region where AHA solution will be deployed"
    type        = string
    default     = "us-east-1"
}

variable "aha_secondary_region" {
    description = "Secondary region where AHA solution will be deployed"
    type        = string
    default     = ""
}

variable "default_tags" {
    description = "Tags used for the AWS resources created by this template"
    type        = map
    default     = {
      Application      = "AHA-Solution"
    }
}

variable "dynamodbtable" {
    type    = string
    default = "AHA-DynamoDBTable"
}

variable "AWSOrganizationsEnabled" {
    type = string
    default = "No"
    description = "You can receive both PHD and SHD alerts if you're using AWS Organizations. \n If you are, make sure to enable Organizational Health View: \n (https://docs.aws.amazon.com/health/latest/ug/aggregate-events.html) to \n aggregate all PHD events in your AWS Organization. If not, you can still \n get SHD alerts."
    validation {
      condition = (
        var.AWSOrganizationsEnabled == "Yes" || var.AWSOrganizationsEnabled == "No"
      )
      error_message = "AWSOrganizationsEnabled variable can only accept Yes or No as values."
    }
}

variable "ManagementAccountRoleArn" {
    type    = string
    default = ""
    description = "Arn of the IAM role in the top-level management account for collecting PHD Events. 'None' if deploying into the top-level management account."
}

variable "AWSHealthEventType" {
    type = string
    default = "issue | accountNotification | scheduledChange"
    description = "Select the event type that you want AHA to report on. Refer to \n https://docs.aws.amazon.com/health/latest/APIReference/API_EventType.html for more information on EventType."
    validation {
      condition = (
        var.AWSHealthEventType == "issue | accountNotification | scheduledChange" || var.AWSHealthEventType == "issue"
      )
      error_message = "AWSHealthEventType variable can only accept issue | accountNotification | scheduledChange or issue as values."
    }
}

#variable "S3Bucket" {
#    type = string
#    description = "Name of your S3 Bucket where the AHA Package .zip resides. Just the name of the bucket (e.g. my-s3-bucket)"
#    validation {
#      condition     = length(var.S3Bucket) > 0
#      error_message = "The S3Bucket cannot be empty."
#    }
#}
#
#variable "S3Key" {
#    type = string
#    description = "Name of the .zip in your S3 Bucket. Just the name of the file (e.g. aha-v1.0.zip)"
#    validation {
#      condition     = length(var.S3Key) > 0
#      error_message = "The S3Key cannot be empty."
#    }
#}

variable "EventBusName" {
    type    = string
    default = ""
    description = "This is to ingest alerts into AWS EventBridge. Enter the event bus name if you wish to send the alerts to the AWS EventBridge. Note: By ingesting you wish to send the alerts to the AWS EventBridge. Note: By ingesting these alerts to AWS EventBridge, you can integrate with 35 SaaS vendors such as DataDog/NewRelic/PagerDuty. If you don't prefer to use EventBridge, leave the default (None)."
}

variable "SlackWebhookURL" {
    type    = string
    default = ""
    description = "Enter the Slack Webhook URL. If you don't prefer to use Slack, leave the default (empty)."
}

variable "MicrosoftTeamsWebhookURL" {
    type    = string
    default = ""
    description = "Enter Microsoft Teams Webhook URL. If you don't prefer to use MS Teams, leave the default (empty)."
}

variable "AmazonChimeWebhookURL" {
    type    = string
    default = ""
    description = "Enter the Chime Webhook URL, If you don't prefer to use Amazon Chime, leave the default (empty)."
}

variable "Regions" {
    type = string
    default = "all regions"
    description = "By default, AHA reports events affecting all AWS regions. \n If you want to report on certain regions you can enter up to 10 in a comma separated format. \n Available Regions: us-east-1,us-east-2,us-west-1,us-west-2,af-south-1,ap-east-1,ap-south-1,ap-northeast-3, \n ap-northeast-2,ap-southeast-1,ap-southeast-2,ap-northeast-1,ca-central-1,eu-central-1,eu-west-1,eu-west-2, \n eu-south-1,eu-south-3,eu-north-1,me-south-1,sa-east-1,global"
}

variable "EventSearchBack" {
    type = number
    default = "1"
    description = "How far back to search for events in hours. Default is 1 hour"
}

variable "FromEmail" {
    type = string
    default = "none@domain.com"
    description = "Enter FROM Email Address"
}

variable "ToEmail" {
    type = string
    default = "none@domain.com"
    description = "Enter email addresses separated by commas (for ex: abc@amazon.com, bcd@amazon.com)"
}

variable "Subject" {
    type = string
    default = "AWS Health Alert"
    description = "Enter the subject of the email address"
}

#variable "S3Bucket" {
#    type = string
#    description = "Name of your S3 Bucket where the AHA Package .zip resides. Just the name of the bucket (e.g. my-s3-bucket)"
#    default = ""
#}

variable "ExcludeAccountIDs" {
    type = string
    default = ""
    description = "If you would like to EXCLUDE any accounts from alerting, enter a .csv filename created with comma-seperated account numbers. Sample AccountIDs file name: aha_account_ids.csv. If not, leave the default empty."
}
