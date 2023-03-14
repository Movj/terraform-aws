//provider "aws" {
//  region = "us-west-2"
//  access_key = "foo"
//  secret_key = "bar"
//}

resource "aws_instance" "myec2" {
  ami = "ami-XXX"
  instance_type = "t2.micro"
}

resource "aws_eip" "myeip" {
  vpc = true
}

resource "aws_eip_association" "my_eip_assoc" {
    instance_id = aws_instance.myec2.id
    allocation_id = aws_eip.myeip.id
}

resource "aws_security_group" "demo" {
  name = "my-var-demo"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.ip] // calling variables from another file
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.ip] // calling variables from another file
  }
}