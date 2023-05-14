provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ec2" {
  source = "./modules/ec2"
}

module "sns" {
  source = "./modules/eventbridge"
  endpoint = var.endpoint
}

module "cw_event_rule" {
  source = "./modules/cloudwatch"
  sns_topic_arn = module.sns.sns_topic_arn
}


