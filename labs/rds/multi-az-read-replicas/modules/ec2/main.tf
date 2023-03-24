resource "tls_private_key" "private_key_example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = "MyKeyPair"
  public_key = tls_private_key.private_key_example.public_key_openssh
}

resource "aws_security_group" "web-server" {
  name        = "MyEc2server-SG"
  description = "Security for ec2 server to connect with RDS"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web-server" {
  ami             = "ami-02e136e904f3da870"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.web-server.name}"]

  user_data = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install mysql -y
    EOF

  tags = {
    Name = "Web Server"
  }
}