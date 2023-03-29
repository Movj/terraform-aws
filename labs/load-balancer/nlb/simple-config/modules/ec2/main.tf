resource "aws_security_group" "ec2-sg" {
  name        = "server-SG"
  description = "Security Group to allow traffic to EC2"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = "myKey"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "ec2" {
  ami             = "ami-01cc34ab2709337aa"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key_pair.key_name
  security_groups = ["${aws_security_group.ec2-sg.name}"]

  user_data = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo “<html> <h1> Response coming from server </h1> </ html>” /var/www/html/index.html
    EOF

  tags = {
    Name = "NLBEC2server"
  }
}