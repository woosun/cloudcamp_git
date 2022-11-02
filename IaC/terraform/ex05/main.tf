provider "aws" {
  region  = "ap-northeast-2"
}

variable "create_ec2" {
    type=bool
    default = true
}

variable "ami" {
    type=string
    default = "ubuntu"
}

resource "aws_instance" "app_server" {
  count = var.create_ec2 ? 1 : 0 #삼항연산자 조건이 ? 참 : 거짓
  ami= var.ami == "ubuntu" ? "ami-068a0feb96796b48d" : var.ami == "amazon" ? "ami-09cf633fe86e51bf0" : "ami-012b9d1d0d2e2c900"
  #var.ami 가 우분투면 우분투설치 amazon이면 아마존 설치 그것도 아니면 윈도우 설치
  instance_type = "t2.micro"
  key_name = "ec01"
  associate_public_ip_address = true #공용아이피주소
  tags = {
    Name = "server"
  }
}
output "app_server_ami" { #출력
  description = "AWS_ami"
  value = var.create_ec2 ? aws_instance.app_server[0].ami : "no create EC2"
  /*
  value = aws_instance.app_server[0].public_ip
  조건이 거짓이면 생성이안되서 오류가 난다.
  */
  #value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}