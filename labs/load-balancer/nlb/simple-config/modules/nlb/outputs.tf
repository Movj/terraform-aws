output "loadbalancer" {
  value = aws_lb.loadbalancer.arn
}

output "nlb_dns_endpoint" {
  value = aws_lb.loadbalancer.dns_name
}