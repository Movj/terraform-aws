resource "tls_private_key" "private_key_example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = "MyKeyPair"
  public_key = tls_private_key.private_key_example.public_key_openssh
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow incoming SSH Connections"
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
  ami             = "ami-01cc34ab2709337aa"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key_pair.key_name
  security_groups = ["${aws_security_group.allow_ssh.name}"]

  tags = {
    Name = "MyEC2Server"
  }
}