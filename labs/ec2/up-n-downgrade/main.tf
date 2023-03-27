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

resource "aws_instance" "web-server" {
    ami             = "ami-01cc34ab2709337aa"
    instance_type   = "t2.micro" #t2.medium, t2.nano you can swich between instance type and terraform will update the ec2 instance easily
    tags = {
        Name = "MyEC2Server"
    }
}