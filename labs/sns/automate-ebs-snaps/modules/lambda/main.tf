data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/source"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "my_lambda_test"
  role             = var.lambda_role
  description      = "Some AWS lambda"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 6
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.cw_event_rule_arn
}