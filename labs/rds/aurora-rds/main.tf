provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "allow_aurora" {
  name        = "Aurora_lab_sg"
  description = "Security group for RDS Aurora"

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

// We'll create a cluster and an Aurora Instance
resource "aws_rds_cluster" "aurorards" {
  cluster_identifier     = "${var.db_name}cluster"
  engine                 = "aurora-mysql"
  database_name          = var.db_name
  master_username        = var.db_user
  master_password        = var.db_password
  vpc_security_group_ids = [aws_security_group.allow_aurora.id]
  storage_encrypted      = false
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = var.db_indentifier
  cluster_identifier = aws_rds_cluster.aurorards.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.aurorards.engine
  engine_version     = aws_rds_cluster.aurorards.engine_version
}