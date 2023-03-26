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

module "iam_lambda_role" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"
  iam_role_arn = module.iam_lambda_role.iam_role_arn
}

module "api_gateway" {
  source = "./modules/apigw"
  test_lambda_function_name = module.lambda.lambda_function_name
  test_lambda_invoke_arn = module.lambda.lambda_invoke_arn
}