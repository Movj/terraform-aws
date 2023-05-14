resource "aws_security_group" "rds-server" {
  name        = "rds-maz-sg"
  description = "Security group for RDS Aurora"

  ingress {
    from_port   = 3306
    to_port     = 3306
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

resource "aws_rds_cluster" "aurorards" {
  cluster_identifier     = "myauroracluster"
  engine                 = "aurora-mysql"
  database_name          = "MyDB"
  availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  master_username        = var.db_user
  master_password        = var.db_password
  vpc_security_group_ids = [aws_security_group.rds-server.id]
  storage_encrypted      = false
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count               = 2
  identifier          = "myaurorainstance${count.index}"
  cluster_identifier  = aws_rds_cluster.aurorards.id
  publicly_accessible = true
  instance_class      = "db.t3.small"
  engine              = aws_rds_cluster.aurorards.engine
  engine_version      = aws_rds_cluster.aurorards.engine_version
}