/// some config

variable "config-per-envs" {
  type = map(string)
  default = {
    "defaul" = "t2.small"
  }
}

/// recovering the current env with the lookup function
resource "aws_instance" "myInstance" {
  ami = "asdasd"
  instance_type = lookup(var.config-per-envs, terraform.workspace)
}

