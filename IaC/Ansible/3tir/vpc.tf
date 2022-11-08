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


#db 생성을 위한 db 서브넷 별도생성
resource "aws_db_subnet_group" "default" {
  name       = "mysql"
  subnet_ids = [aws_subnet.my-subnet["a"].id,aws_subnet.my-subnet["c"].id]
  tags = {
    Name = "My DB subnet group"
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

#라우팅테이블 연결
resource "aws_route_table_association" "my-subnet_my-ro-table" {
  for_each = var.my-vpc-subnet
  subnet_id = aws_subnet.my-subnet["${each.key}"].id
  route_table_id = aws_default_route_table.my-route-table.id
}