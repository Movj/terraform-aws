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

resource "aws_eks_cluster" "cluster" {
  name = "eks_cluster"
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}