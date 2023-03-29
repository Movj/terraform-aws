output "public_ec2_instance_id" {
  value = aws_instance.public_ec2_instance.id
}
output "private_ec2_instance_id" {
  value = aws_instance.private_ec2_instance.id
}
output "public_ec2_instance_ip" {
  value = aws_instance.public_ec2_instance.public_ip
}