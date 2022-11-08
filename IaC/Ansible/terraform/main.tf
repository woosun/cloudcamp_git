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
#서브넷 a,b
resource "aws_subnet" "my-subnet1" {
  vpc_id = aws_vpc.my-vpc2.id
  cidr_block = "200.200.10.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet1"
  }
}
#인터넷게이트웨이
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
resource "aws_route_table_association" "my-subnet1_my-ro-table" {
  subnet_id      = aws_subnet.my-subnet1.id
  route_table_id = aws_route_table.my-ro-table.id
}
#보안그룹
resource "aws_security_group" "ec2_allow_rule" {
  vpc_id      = aws_vpc.my-vpc2.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http,https"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_from_all"
  }
}
resource "aws_instance" "app_server" {
  ami           = var.app_server_ami
  instance_type = var.app_server_in_type
  key_name = "ec01"
  subnet_id = aws_subnet.my-subnet1.id #서브넷아이디
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = [ aws_security_group.ec2_allow_rule.id ] #resource "aws_security_group" "ec2_allow_rule" 를 가져와서 설정해준다
  tags = {
    Name = var.app_server_name
  }

  provisioner "local-exec" {
    command = <<EOF
        echo "[all]" > inventory
        echo "${aws_instance.app_server.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/key" >> inventory
        sleep 30
        EOF
  }
  provisioner "local-exec" {
    command = <<EOF
        ANSIBLE_HOST_KEY_CHECKING=False \
        ansible-playbook -i inventory ~/web_install.yml
    EOF
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = aws_instance.app_server.public_ip

}
# enable_dns_hostnames- (선택 사항) VPC에서 DNS 호스트 이름을 활성화/비활성화하는 부울 플래그. 기본값은 false입니다.