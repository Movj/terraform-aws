provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1         // decribes ONE STRONGLY CONSISTENT READ per second, upto 1 Kb in size.
  write_capacity = 1         // describes ONE STRONGLY CONSISTENT WERITE per second, upto 1 KB in size.
  hash_key       = "RollNo." // partition key of an item. Composed of one attribute that acts as a PRIMARY KEY for the table.

  attribute {
    name = "RollNo."
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
  {
    "RollNo.": {"N": "1"},
    "Name": {"S": "Test"}
  }
  ITEM
}

resource "aws_dynamodb_table_item" "item2" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
    {
    "RollNo.": {"N": "2"},
    "Name": {"S": "Foo"}
    }
    ITEM
}

resource "aws_dynamodb_table_item" "item3" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
    {
    "RollNo.": {"N": "3"},
    "Name": {"S": "Bar"}
    }
    ITEM
}