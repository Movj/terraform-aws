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

module "networking" {
  source = "./modules/networking"
}

module "ec2" {
  source            = "./modules/ec2"
  main_vpc_id       = module.networking.vpc_id
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  key_pair_name = var.key_pair
}