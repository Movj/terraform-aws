resource "aws_instance" "private_ec2_instance" {
  ami                         = "ami-02e136e904f3da870"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.ec2_sg.id}"]
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_pair_name

  tags = {
    Name = "My Private EC2 Server"
  }

  depends_on = [aws_security_group.ec2_sg]
}