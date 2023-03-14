provider "aws" {
  region = "us-east-2"
  access_key = "asdasd"
  secret_key = "asdasd"
}

resource "aws_instance" "ec2" {
    ami = "ami-0f3c9c466bb525749"
    instance_type = "t2.micro"
}