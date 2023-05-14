resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc_flow_log_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "vpc-flow-logs.amazonaws.com"
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_policy_attach" {
  role       = aws_iam_role.vpc_flow_log_role.name
  policy_arn = "arn:aws:iam::XXXXXXXXXXXX:policy/VPCFlowLog_Rolepolicy"
}

resource "aws_iam_instance_profile" "vpc_flow_log_instance_profile" {
  name = "VPCFlowLog_Instance_profile"
  role = aws_iam_role.vpc_flow_log_role.name
}

// to see a better way to create a role check /labs/apigw/lambda-integration lab.