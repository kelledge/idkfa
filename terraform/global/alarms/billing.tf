resource "aws_cloudwatch_metric_alarm" "billing_critical" {
  alarm_name          = "billing_critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "3600"
  statistic           = "Maximum"
  threshold           = 10.00

  alarm_description = "This metric monitors estimated charges for critical levels"
  alarm_actions     = ["${data.terraform_remote_state.topics.critical_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "billing_warn" {
  alarm_name          = "billing_warn"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "3600"
  statistic           = "Maximum"
  threshold           = 3.00

  alarm_description = "This metric monitors estimated charges for warning levels"
  alarm_actions     = ["${data.terraform_remote_state.topics.warn_arn}"]
}
