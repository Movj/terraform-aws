terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# users creation
resource "aws_iam_user" "user1" {
  name = "John"
  path = "/"
  tags = {
    tag-key = "Dev-Team"
  }
}

resource "aws_iam_user" "user2" {
  name = "Sarah"
  path = "/"
  tags = {
    tag-key = "Dev-Team"
  }
}

resource "aws_iam_user" "user3" {
  name = "Rita"
  path = "/"
  tags = {
    tag-key = "HR-Team"
  }
}

resource "aws_iam_user" "user4" {
  name = "Ted"
  path = "/"
  tags = {
    tag-key = "HR-Team"
  }
}

# groups creation
resource "aws_iam_group" "group1" {
  name = "DevTeam"
}

resource "aws_iam_group" "group2" {
  name = "HRTeam"
}

# membership association
resource "aws_iam_group_membership" "member1" {
  name = "user1"
  users = [
    aws_iam_user.user1.name,
    aws_iam_user.user2.name,
  ]
  group = aws_iam_group.group1.name
}

resource "aws_iam_group_membership" "member2" {
  name = "user2"
  users = [
    aws_iam_user.user3.name,
    aws_iam_user.user4.name,
  ]
  group = aws_iam_group.group2.name
}