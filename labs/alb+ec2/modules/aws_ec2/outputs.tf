
output "ec2_id" {
  value = aws_instance.ec2.id
}

output "http_sg_id" {
  value = aws_security_group.allow_http_sg.id
}