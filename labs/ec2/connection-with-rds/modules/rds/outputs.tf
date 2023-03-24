output "rds_sg" {
  value = aws_security_group.rds_sg.name
}

output "db_instance_endpoint" {
  value = aws_db_instance.mysql_instance.endpoint
}
