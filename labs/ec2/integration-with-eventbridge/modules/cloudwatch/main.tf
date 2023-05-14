resource "aws_cloudwatch_event_rule" "event" {
  name        = "MyEC2StateChangeEvent"
  description = "MyEC2StateChangeEvent"
  event_pattern = <<EOF
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "SendToSNS"
  arn       = var.sns_topic_arn
}

