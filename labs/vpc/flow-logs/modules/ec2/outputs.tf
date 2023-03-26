output "ec2_instance_ip" {
  value = aws_instance.instance.associate_public_ip_address
}

output "ec2_instance_id" {
  value = aws_instance.instance.id
}

output "ec2_instance_public_dns" {
  value = aws_instance.instance.public_dns
}