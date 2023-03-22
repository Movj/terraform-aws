output "standard_sqs_arn" {
  value = aws_sqs_queue.standard_queue.arn
}
output "fifo_sqs_arn" {
  value = aws_sqs_queue.fifo_queue.arn
}