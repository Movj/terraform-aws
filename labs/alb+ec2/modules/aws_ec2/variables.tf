// variables for aws_ec2 module

variable "key_pair_config" {
  type = map(any)
  default = {
    key_name    = "remote-key"
    private_key = "route here"
    user        = "ec2-user"
  }
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
