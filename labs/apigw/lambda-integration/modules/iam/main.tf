data "aws_iam_policy_document" "policy_base" {
  statement {
    sid = "LambdaPolicy"
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = ["*"]
    condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:RequestedRegion"
        values   = ["us-east-1"]
    }
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = "LambdaPolicy"
  path = "/"
  policy = data.aws_iam_policy_document.policy_base.json
}

data "aws_iam_policy_document" "iam_role_policy_base" {
  statement {
    actions = [
        "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.iam_role_policy_base.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}