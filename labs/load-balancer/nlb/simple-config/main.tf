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

module "ec2" {
  source = "./modules/ec2"
}

module "nlb" {
  source = "./modules/nlb"
  ec2_instance_id = module.ec2.ec2_instance_id
}