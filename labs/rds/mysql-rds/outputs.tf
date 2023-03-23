output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
output "db_instance_endpoint" {
  value = aws_db_instance.myinstance.endpoint
}