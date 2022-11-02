provider "aws" { 
  region  = "ap-northeast-2" #리전명
}
#vpc
resource "aws_vpc" "my-vpc2" {
  cidr_block       = "200.200.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name = "my-vpc2"
  }
}

resource "aws_subnet" "my-subnet_a" {
  vpc_id = aws_vpc.my-vpc2.id
  cidr_block = "200.200.10.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet_a"
  }
}
resource "aws_subnet" "my-subnet_c" {
  vpc_id = aws_vpc.my-vpc2.id
  cidr_block = "200.200.20.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet_c"
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
  subnet_id      = aws_subnet.my-subnet_a.id
  route_table_id = aws_route_table.my-ro-table.id
}


resource "aws_security_group" "default_sg_add" {
  for_each = var.sg_list
  dynamic ingress {
    for_each = var.each.value.
    
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${each.key}"
  }
}
