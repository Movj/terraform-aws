resource "aws_security_group" "web-sg" {
  name = "Web-SG"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "web" {
    ami = "ami-02e136e904f3da870"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    iam_instance_profile = var.ec2_role
    user_data = <<EOF

    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    aws s3 cp s3://${var.s3_bucket_id}/index.html  /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF

  tags = {
    Name = "EC2-Instance"
  }
}