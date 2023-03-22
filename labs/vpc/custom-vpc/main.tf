provider "aws" {
     region     = "${var.region}"
     access_key = "${var.access_key}"
     secret_key = "${var.secret_key}"
}

resource "aws_vpc" "custom-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "Custom VPC"
    }
}

resource "aws_subnet" "public-subnet" {
   vpc_id = aws_vpc.custom-vpc.id
   cidr_block = "10.0.1.0/24"
   map_public_ip_on_launch = true
   availability_zone = "us-east-1a"
   tags = {
    "Name": "Public Subnet"
   }
}

resource "aws_subnet" "private-subnet" {
    vpc_id = "${aws_vpc.custom-vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags =  {
        Name = "Private Subnet"
    }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.custom-vpc.id}"
    tags = {
      "Name" = "Internet Gateway"
    }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    "Name" = "Public Route Table"
  }
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.custom-vpc.id

  // No route definition for private route table

  tags = {
    "Name": "Private Route Table"
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "private-association" {
  subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.privatert.id
}