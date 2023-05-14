resource "aws_cloudwatch_event_rule" "event" {
  name                = "event-rule"
  schedule_expression = "rate(1 hour)"
  event_pattern       = <<EOF
    {
        "source": [
            "aws.ec2"
        ],
        "detail-type": [
            "EC2 Instance State-change Notification"
        ],
    "detail": {
        "state": [
                "stopped"
            ],
            "instance-id": [
                "${var.target_instance_id}"
            ]
        }
    }
EOF
}