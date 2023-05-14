// variables for main.tf and which can be usable inside all modules (common variables)

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 Instances"
  type        = string
  default     = "t2.micro"
}

variable "default_vpc_id" {
  description = "It is the ID of the VPC created by default"
  type        = string
}

variable "subnets" {
  description = "List of the subnets' ID to use"
  type        = list(string)
}
