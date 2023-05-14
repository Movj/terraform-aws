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

module "ec2_instance" {
  source = "./modules/ec2"
}

module "cw_event_rule" {
  source = "./modules/cw"
  target_instance_id = module.ec2_instance.instance_id
}

module "lambda" {
  source = "./modules/lambda"
  lambda_role = var.lambda_role
  cw_event_rule_arn = module.cw_event_rule.cw_event_rule_arn
}

module "sns_topic" {
  source = "./modules/sns"
  sns_role = var.sns_role
  lambda_function_arn = module.lambda.function_arn
  lambda_function_name = module.lambda.function_name
}

#CloudWatch event target associations
resource "aws_cloudwatch_event_target" "cw_event_to_sns_topic_association" {
  rule      = module.cw_event_rule.cw_event_rule_name
  target_id = "SendToSNS"
  arn       = module.sns_topic.sns_topic_arn
}

resource "aws_cloudwatch_event_target" "cw_event_to_lambda_association" {
  rule      = module.cw_event_rule.cw_event_rule_name
  target_id = "SendToLambda"
  arn       = module.lambda.function_arn
}



