resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "MySSHKey"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "EC2 security group to allow incoming SSH and HTTP connections"
  vpc_id      = var.shared_vpc_id

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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_instance" "instance" {
  depends_on = [aws_security_group.ec2_sg]

  ami                         = "ami-02e136e904f3da870"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.ec2_sg.id}"]
  subnet_id                   = var.shared_subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile_name
  key_name                    = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = "EC2 Instance for Test"
  }
}   