resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "MySubnet"
  }
}
# to see more examples of vpc definition: labs/vpc/custom-vpc

# Create a VPC Flow Logs

resource "aws_flow_log" "my_flow_log" {
  vpc_id                   = aws_vpc.vpc.id
  iam_role_arn             = var.vpc_flow_log_iam_role_arn
  traffic_type             = "ACCEPT"
  log_destination          = var.cloudwatch_log_group_arn
  max_aggregation_interval = 60
}