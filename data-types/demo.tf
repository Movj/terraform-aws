provider "aws" {
  region = "us-west-2"
  access_key = "foo"
  secret_key = "bar"
}

resource "aws_iam_user" "user" {
  name = var.username
  path = "/system/"
}



// to use maps and lists...
variable "list" {
    type = list
    default = ["val"]
}

// using a list of specific type
variable "ports" {
  type = list(number)
  default = [ 1 ]
}

resource "aws_security_group" "dynamic-block-demo" {
  name = "my-security grouo"
  dynamic "ingress" { // dynamic indicates that the content will be created dynamically
    for_each = var.ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "types" {
    type = map
    default = {
        us-east-2 = "t2.micro"
    }
}

resource "aws_instance" "ec2" {
  ami = "asdad"
  instance_type = var.list[0]
}

resource "aws_instance" "ec2-2" {
  ami = "asdad"
  instance_type = var.types["us-east-2"]
}



//using local variables
locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  common_tags = {
    Owner = "Team X"
    service = "Engineering"
  }
}

output "timestamp" {
  value = local.time
}

// using conditional expressions
resource "aws_instance" "ec2-3" {
  ami = "asdad"
  instance_type = var.types["us-east-2"]
  count = var.flag == true ? 2 : 0
  tags = local.common_tags
}

// we can use the function lookup
/*
* something = lookup(var.map, var.value_to_search)
*/


// using a loop to create a resource dynamically
resource "aws_iam_user" "users" {
  name = "iamuser.${count.index}"
  count = 3
  path = "/system/"
}

output "arns" {
  value = aws_iam_user.users[*].arn // check this statement
}