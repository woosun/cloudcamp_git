resource "aws_vpc" "my-vpc" {
  cidr_block       = "200.200.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_subnet" "my-subnet" {
  for_each = var.my-vpc-subnet
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = each.value
  availability_zone = "ap-northeast-2${each.key}"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-${each.key}"
  }
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}
resource "aws_default_route_table" "my-route-table" {
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "my-route-table"
  }
}