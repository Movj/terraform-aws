output "instance_public_id" {
  value = module.ec2.ec2_instance_ip
}

output "instance_public_dns" {
  value = module.ec2.ec2_instance_public_dns
}