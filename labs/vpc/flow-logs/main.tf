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

module "cloudwatch_log_group" {
  source = "./modules/cloudwatch"
}

module "iam_role_for_vpc_flow_log" {
  source = "./modules/iam"
}

module "vpc_flow_log" {
  source                    = "./modules/vpc"
  cloudwatch_log_group_arn  = module.cloudwatch_log_group.arn
  vpc_flow_log_iam_role_arn = module.iam_role_for_vpc_flow_log.arn
}

module "ec2" {
  source                = "./modules/ec2"
  shared_vpc_id         = module.vpc_flow_log.vpc_id
  shared_subnet_id      = module.vpc_flow_log.subnet_id
  instance_profile_name = module.iam_role_for_vpc_flow_log.instance_profile_name
}