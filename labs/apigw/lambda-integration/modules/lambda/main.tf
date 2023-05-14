/* resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "MyLambdaTest"
  role          = var.iam_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/code/lambda_function.zip")
} */

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/source"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "my_lambda_test"
  role             = var.iam_role_arn
  description      = "Some AWS lambda"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
}