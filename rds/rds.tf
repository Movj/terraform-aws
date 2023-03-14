provider "aws" {
  region = "us-east-2"
  access_key = "asdasd"
  secret_key = "asdasd"
}

resource "aws_db_instance" "default" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  name = "mydb"
  username = "foo"
  password = "foobarz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}

// we can also manage auto-scalling, multi-az deployments etc