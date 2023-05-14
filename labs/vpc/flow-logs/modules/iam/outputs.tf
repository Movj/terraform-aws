output "arn" {
  value = aws_iam_role.vpc_flow_log_role.arn
}

output "id" {
  value = aws_iam_role.vpc_flow_log_role.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.vpc_flow_log_instance_profile.name
}