output "db_instance_endpoint" {
  value = aws_rds_cluster_instance.cluster_instances.endpoint
}
output "db_sg_id" {
  value = aws_security_group.allow_aurora.id
}