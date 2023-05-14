provider "aws" {
  region = "us-east-2"
  access_key = "asdasd"
  secret_key = "asdasd"
}


resource "aws_security_group" "allow_port22" {
  name = "allow_port22"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// basic provisioner
resource "aws_instance" "ec2" {
  ami = "some-id"
  instance_type = "t2.micro"
  key_name = "myKey" // tf will use it directly from aws
  vpc_security_group_ids = [aws_security_group.allow_port22.id]

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("./myKey.pem") // must create the key-pair before
      host = self.public_ip
    }
  }
}

// advance provisioner
resource "aws_instance" "ec2-advanced" {
  ami = "some-id"
  instance_type = "t2.micro"
  key_name = "myKey" // tf will use it directly from aws
  vpc_security_group_ids = [aws_security_group.allow_port22.id]

  provisioner "remote-exec" {
    on_failure = fail // control exceptions
    inline = [
      "sudo yum -y install nano"
    ]
  }

  provisioner "remote-exec" {
    when = destroy // event specific
    
    inline = [
      "sudo yum -y remove nano"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("./myKey.pem") // must create the key-pair before
      host = self.public_ip
    }
  }
}