# Alarms
Organization level alarms. Many of these alarms are inspired from the following
examples:

 * http://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail.html
 * http://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail-additional-examples.html

## Billing Alarms
Currently has two levels -- warn and critical.

I believe warn should trigger when your calculated bill is going to exceed your
calculated budget.

The critical threshold should be set at your maximum monthly budget. You will
likely be destroying or releasing resources as a result of receiving this
alarm.

## Root Usage (WIP)
Triggers a warning alarm when the root account is used. In general, root login
should be avoided, but there are some actions that only the root account user
can perform.
http://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html

## Authorization Failure (WIP)
Triggers when on API authorization failures

## Console Sign-In Failures (WIP)
Triggers on excessive sign-in failures

## CloudTrail Changes (WIP)
Notify when audit policy is changed.
