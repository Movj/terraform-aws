
variable "default_vpc_id" {
  description = "It is the ID of the VPC created by default"
  type = string
}

variable "subnets" {
  description = "List of the subnets' ID to use"
  type = list(string)
}

variable "target_id" {
  description = "ID of the EC2 instance to link"
  type = string
}

variable "target_sg" {
  description = "ID of the Security Group to link"
}