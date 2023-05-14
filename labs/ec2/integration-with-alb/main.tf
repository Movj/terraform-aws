terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # adding backed as S3 for Remote State Storage
  backend "s3" {
    bucket = "jimv-labs-terraform-1996"
    key    = "dev/lab-alb+ec2/terraform.tfstate"
    region = "us-east-2"

    # state locking
    dynamodb_table = "dev-lab-alb-ec2"
    profile        = "dev"
  }
}

provider "aws" {
  region = var.aws_region
  access_key = "asdasd"
  secret_key = "asdasd"
}

provider "aws" {
  region  = "us-east-2"
  alias   = "dev"
  profile = "dev"
}

module "aws_ec2" {
  source = "./modules/aws_ec2"
  # pass variables or outputs from modules
  default_vpc_id = var.default_vpc_id
  subnets        = var.subnets
}

module "aws_alb" {
  source = "./modules/aws_alb"
  # pass variables or outputs from modules
  target_id      = module.aws_ec2.ec2_id
  target_sg      = module.aws_ec2.http_sg_id
  default_vpc_id = var.default_vpc_id
  subnets        = var.subnets
}