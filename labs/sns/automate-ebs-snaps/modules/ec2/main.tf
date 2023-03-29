resource "aws_security_group" "ec2-sg" {
    name        = "server-sg"
    description = "Security Group to allow traffic to EC2"
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

resource "aws_instance" "ec2" {
    ami             = "ami-01cc34ab2709337aa"
    instance_type   = "t2.micro"
    security_groups = ["${aws_security_group.ec2-sg.name}"]
    tags = {
        Name = "My Server"
    }
}