// defining and calling a module

module "myModule" {
  source = "../ec2-modules"
}

// using a module from an external provider
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami = "asdasdad"
  instance_type = "t2.micro"
  key_name = "myKey" // ssh key
  monitoring = true
  vpc_security_group_ids = ["some-id"]
  subnet_id = "some-id"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}