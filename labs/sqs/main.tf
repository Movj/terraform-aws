provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sqs_queue" "fifo_queue" {
  name = "${var.queue_name}.fifo"
  fifo_queue = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "standard_queue" {
  name = var.queue_name
}