output "vpc_flow_log_arn" {
  value = aws_flow_log.my_flow_log.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}