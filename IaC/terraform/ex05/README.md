    terraform init	초기화
    terraform validate	검증
    terraform plan	계획
    terraform apply	적용 -var 변수명=값
    terraform destroy	제거
    terraform show	상태 확인


# Terraform  조건문

- 조건문
-  [1] count를 이용한 방법
#
    variable "create_ec2" {
        type= bool
        default = true
    }
    resource "aws_instance" "app_server" {
        count = var.create_ec2 ? 1 : 0
        ami           = "ami-068a0feb96796b48d"
        instance_type = "t2.micro"
        key_name = "cloudkey"
        tags = {
            Name = "server"
        }
    }

-  [2] 삼항연산자를 이용한 방법

# 
    variable "create_ec2" {
        type=bool
        default = true
    }
    resource "aws_instance" "app_server" {
        count = var.create_ec2 ? 1 : 0 #삼항연산자 조건이 ? 참 : 거짓
        ami= ami-068a0feb96796b48d"
        instance_type = "t2.micro"
        key_name = "ec01"
        associate_public_ip_address = true #공용아이피주소
        tags = {
            Name = "server"
        }
    }

- 조건을 걸때 오토스케일링이나 로드벨런서 사용여부 이런부분에 사용한다.



- 실습 EC2를 생성할떄 변수로 ami 가 ubuntu로 입력하면 ami-068a0feb96796b48d
- ami를 amazon을 입력하면 ami-09cf633fe86e51bf0가 실행되게 하라.
#
    variable "ami" {
        type=string
        default = "ubuntu"
    } 
    ami= var.ami == "ubuntu" ? "ami-068a0feb96796b48d" : var.ami == "amazon" ? "ami-09cf633fe86e51bf0" : "ami-012b9d1d0d2e2c900"
    #var.ami 가 우분투면 우분투설치 amazon이면 아마존 설치 그것도 아니면 윈도우 설치

  ## 조건을 배웠으니 아까 연습하던 EC2의 보안그룹을 수정한다.
  