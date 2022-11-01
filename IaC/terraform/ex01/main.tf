terraform { # 굳이안써도 자동생성됨
  required_providers { #어디서 운영할건지
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

#설치할곳은 AWS고 리전은 ap-northeast-2 이다.
provider "aws" { 
  region  = "ap-northeast-2" #리전명
}

#AWS에 리소스를 추가하는데 aws_security_group 라는것을 추가한다.
resource "aws_security_group" "ec2_allow_rule" {
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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


variable "app_server_ami" {
  type = string
  default = "ami-068a0feb96796b48d"
}

variable "app_server_in_type" {
  type = string
  default = "t2.micro"
}

resource "aws_instance" "app_server" { #리소스
  ami           = var.app_server_ami #이미지명 > 변수로 만듬
  instance_type = var.app_server_in_type
  vpc_security_group_ids = [ aws_security_group.ec2_allow_rule.id ] #resource "aws_security_group" "ec2_allow_rule" 를 가져와서 설정해준다
  tags = {
    Name = "ExampleAppServerInstance"
  }
}

#output "name" { #출력
  
#}