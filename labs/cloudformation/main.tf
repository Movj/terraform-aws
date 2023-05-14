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

# Creating Key pair for EC2
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "my-test-key" {
  key_name   = "my-test-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_cloudformation_stack" "my-test-stack" {
  depends_on = [
    aws_key_pair.my-test-key
  ]

  parameters = {
    DBName         = "MyDatabase"
    DBPassword     = var.db_password
    DBRootPassword = var.db_rootpass
    DBUser         = var.db_username
    InstanceType   = "t2.micro"
  }

  name          = "my-test-stack"
  template_body = file("cf-template.json")
}