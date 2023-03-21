resource "aws_sns_topic" "topic" {
  name = var.topic_name
  policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement":[
            {
                "Effect":"Allow",
                "Principal": {
                    "Service": "s3.amazonaws.com"
                },
                "Action": "SNS:Publish",
                "Resource": "arn:aws:sns:*:*:${var.topic_name}",
                "Condition": {
                    "ArnLike": {
                        "aws:SourceArn": "${var.bucket_arn}"
                    }
                }
            }
        ]
    }
  POLICY
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol = "email"
  endpoint = var.endpoint
}