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

resource "aws_launch_template" "launch_template" {
  name_prefix   = "myLT"
  image_id      = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "asg" {
  name               = "svc-ASG1"
  availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}