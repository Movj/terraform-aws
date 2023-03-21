// we will define all outputs from the modules defined in the main.tf file

output "ec2_id" {
  description = "ID of the EC2 instance created"
  value       = module.aws_ec2.ec2_id // module.aws_ec2.[output_name]
}

output "alb_dns_name" {
  description = "DNS of the Application Load Balancer created"
  value       = module.aws_alb.alb-dns-name // module.aws_alb.[output_name]
}