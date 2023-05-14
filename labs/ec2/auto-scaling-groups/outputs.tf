output "launch_template_arn" {
  value = aws_launch_template.launch_template.arn
}

output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}