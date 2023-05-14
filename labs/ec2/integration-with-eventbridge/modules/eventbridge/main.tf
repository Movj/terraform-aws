resource "aws_sns_topic" "topic" {
  name = "MyServerMonitor"
}

resource "aws_sns_topic_subscription" "topic-subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.endpoint
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.topic.arn]
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

// you can see another example of sns topic definition at labs/s3/notification-with-sns/