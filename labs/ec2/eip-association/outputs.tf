output "elastic_ip" {
  value = aws_eip.ip.public_ip
}
output "instance_id" {
  value = aws_instance.web-server.id
}