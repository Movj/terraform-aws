terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.59.0"
    }
  }
}

provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

module "rds" {
  source = "./modules/rds"
  db_user = var.db_user
  db_password = var.db_password
  db_indentifier = var.db_indentifier
}

module "ec2" {
  source = "./modules/ec2"
  rds_sg = module.rds.rds_sg
}