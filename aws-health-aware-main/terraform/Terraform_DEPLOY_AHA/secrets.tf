# Secrets - SlackChannelSecret
resource "aws_secretsmanager_secret" "SlackChannelID" {
    count = "${var.SlackWebhookURL == "" ? 0 : 1}"
    name             = "SlackChannelID"
    description      = "Slack Channel ID Secret"
    recovery_window_in_days      = 0
    tags             = {
        "HealthCheckSlack" = "ChannelID"
    }
    dynamic "replica" {
      for_each = var.aha_secondary_region == "" ? [] : [1]
      content {
        region = var.aha_secondary_region
      }
    }
}
resource "aws_secretsmanager_secret_version" "SlackChannelID" {
    count = "${var.SlackWebhookURL == "" ? 0 : 1}"
    secret_id     = "${aws_secretsmanager_secret.SlackChannelID.*.id[count.index]}"
    secret_string = "${var.SlackWebhookURL}"
}

# Secrets - MicrosoftChannelSecret
resource "aws_secretsmanager_secret" "MicrosoftChannelID" {
    count = "${var.MicrosoftTeamsWebhookURL == "" ? 0 : 1}"
    name             = "MicrosoftChannelID"
    description      = "Microsoft Channel ID Secret"
    recovery_window_in_days      = 0
    tags             = {
        "HealthCheckMicrosoft" = "ChannelID"
        "Name"                 = "AHA-MicrosoftChannelID"
    }
    dynamic "replica" {
      for_each = var.aha_secondary_region == "" ? [] : [1]
      content {
        region = var.aha_secondary_region
      }
    }
}
resource "aws_secretsmanager_secret_version" "MicrosoftChannelID" {
    count = "${var.MicrosoftTeamsWebhookURL == "" ? 0 : 1}"
    secret_id     = "${aws_secretsmanager_secret.MicrosoftChannelID.*.id[count.index]}"
    secret_string = "${var.MicrosoftTeamsWebhookURL}"
}

# Secrets - EventBusNameSecret
resource "aws_secretsmanager_secret" "EventBusName" {
    count = "${var.EventBusName == "" ? 0 : 1}"
    name             = "EventBusName"
    description      = "EventBus Name Secret"
    recovery_window_in_days      = 0
    tags             = {
        "EventBusName" = "ChannelID"
        "Name"         = "AHA-EventBusName"
    }
    dynamic "replica" {
      for_each = var.aha_secondary_region == "" ? [] : [1]
      content {
        region = var.aha_secondary_region
      }
    }
}

resource "aws_secretsmanager_secret_version" "EventBusName" {
    count = "${var.EventBusName == "" ? 0 : 1}"
    secret_id     = "${aws_secretsmanager_secret.EventBusName.*.id[count.index]}"
    secret_string = "${var.EventBusName}"
}

# Secrets - ChimeChannelSecret
resource "aws_secretsmanager_secret" "ChimeChannelID" {
    count = "${var.AmazonChimeWebhookURL == "" ? 0 : 1}"
    name             = "ChimeChannelID"
    description      = "Chime Channel ID Secret"
    recovery_window_in_days      = 0
    tags             = {
        "HealthCheckChime" = "ChannelID"
        "Name"             = "AHA-ChimeChannelID-${random_string.resource_code.result}"
    }
    dynamic "replica" {
      for_each = var.aha_secondary_region == "" ? [] : [1]
      content {
        region = var.aha_secondary_region
      }
    }
}
resource "aws_secretsmanager_secret_version" "ChimeChannelID" {
    count = "${var.AmazonChimeWebhookURL == "" ? 0 : 1}"
    secret_id     = "${aws_secretsmanager_secret.ChimeChannelID.*.id[count.index]}"
    secret_string = "${var.AmazonChimeWebhookURL}"
}

# Secrets - AssumeRoleSecret
resource "aws_secretsmanager_secret" "AssumeRoleArn" {
    count = "${var.ManagementAccountRoleArn == "" ? 0 : 1}"
    name             = "AssumeRoleArn"
    description      = "Management account role for AHA to assume"
    recovery_window_in_days      = 0
    tags             = {
        "AssumeRoleArn" = ""
        "Name"          = "AHA-AssumeRoleArn"
    }
    dynamic "replica" {
      for_each = var.aha_secondary_region == "" ? [0] : [1]
      content {
        region = var.aha_secondary_region
      }
    }
}
resource "aws_secretsmanager_secret_version" "AssumeRoleArn" {
    count = "${var.ManagementAccountRoleArn == "" ? 0 : 1}"
    secret_id     = "${aws_secretsmanager_secret.AssumeRoleArn.*.id[count.index]}"
    secret_string = "${var.ManagementAccountRoleArn}"
}
