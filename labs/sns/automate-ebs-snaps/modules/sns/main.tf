resource "aws_sns_topic" "topic" {
  name = "my-topic"
  lambda_success_feedback_sample_rate = "100"
  lambda_success_feedback_role_arn = var.sns_role
  lambda_failure_feedback_role_arn  = var.sns_role
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "lambda"
  endpoint  = var.lambda_function_arn
}

#Additional Lambda configuration
resource "aws_lambda_function_event_invoke_config" "lambda_to_sns_association" {
  function_name = var.lambda_function_name
  destination_config {
    on_failure {
      destination = aws_sns_topic.topic.arn
    }
    on_success {
      destination = aws_sns_topic.topic.arn
    }
  }
}