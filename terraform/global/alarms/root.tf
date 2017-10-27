resource "aws_cloudwatch_log_metric_filter" "root_account_usage" {
  name           = "RootAccountUsage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = "${data.terraform_remote_state.audit.cloudwatch_log_group_name}"

  metric_transformation {
    name      = "RootUsage"
    namespace = "Organization"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_account_usage" {
  alarm_name          = "RootAccountUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RootAccountUsage"
  namespace           = "Organization"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "This metric monitors root account usage"
  alarm_actions     = ["${data.terraform_remote_state.topics.warn_arn}"]
}
