output "vpc_id" {
  value = aws_vpc.custom-vpc.id
}
output "public_subnet" {
  value = aws_subnet.public-subnet.id
}
output "private_subnet" {
  value = aws_subnet.private-subnet.id
}