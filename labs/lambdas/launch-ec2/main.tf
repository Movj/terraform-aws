terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

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
  timeout          = 6
}