# in this lab, we will use the default vpc and subnets check lab [] for a complete definition

resource "aws_security_group" "allows_ssh_sg" {
  name = "allows_ssh_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// in this case, we need to allow egress of traffic by port 80 to allow response from the web server
resource "aws_security_group" "allow_http_sg" {
  name   = "allow_http_sg"
  vpc_id = var.default_vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // from all, lab purpose only
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // from all, lab purpose only
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // to all, lab purpose only
  }
}

// instances
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.allow_http_sg.id, aws_security_group.allows_ssh_sg.id]
  associate_public_ip_address = true
  key_name                    = lookup(var.key_pair_config, "key_name")

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(lookup(var.key_pair_config, "private_key"))
      host        = self.public_ip
    }
  }
}