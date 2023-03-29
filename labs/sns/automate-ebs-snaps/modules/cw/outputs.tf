output "cw_event_rule_name" {
  value = aws_cloudwatch_event_rule.event.name
}

output "cw_event_rule_arn" {
  value = aws_cloudwatch_event_rule.event.arn
}