resource "aws_eip" "eip-ohio" {
  vpc = "true"
  provider = aws.ohio
}

resource "aws_eip" "eip-virginia" {
  vpc = "true"
  provider = aws.virginia
}