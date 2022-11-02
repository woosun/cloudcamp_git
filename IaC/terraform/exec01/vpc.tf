#vpc
resource "aws_vpc" "my-vpc2" {
  cidr_block       = "200.200.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name = "my-vpc2"
  }
}
resource "aws_subnet" "my-subnet" {
  vpc_id = aws_vpc.my-vpc2.id
  for_each = var.subnet_list
  cidr_block = each.value
  availability_zone = "ap-northeast-2${each.key}"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet_${each.key}"
  }
}
resource "aws_internet_gateway" "my-igw2" {
    vpc_id = aws_vpc.my-vpc2.id
    tags = {
      Nmae = "my-igw2"
    }
}
#라우팅테이블
resource "aws_route_table" "my-ro-table" {
  vpc_id = aws_vpc.my-vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw2.id
  }

  tags = {
    Name = "my-ro-table"
  }
}
resource "aws_route_table_association" "my-subnet_a_my-ro-table" {
  subnet_id      = aws_subnet.my-subnet["a"].id
  route_table_id = aws_route_table.my-ro-table.id
}