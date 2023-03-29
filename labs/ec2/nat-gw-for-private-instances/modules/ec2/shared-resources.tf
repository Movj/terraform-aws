# Create Security group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security Group to allow traffic to EC2"
  vpc_id      = var.main_vpc_id

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

  tags = {
    Name = "ec2-sg"
  }
}