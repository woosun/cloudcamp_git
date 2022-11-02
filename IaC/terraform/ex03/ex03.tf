provider "aws" { 
  region  = "ap-northeast-2" #리전명
}



variable "sg_port" {
  type        = map
  default     = {
    "22" : ["221.162.65.184/32"]
    "80" : ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "default_sg_add" {
  dynamic ingress {
    for_each = var.sg_port
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
    Name = "default_sg_add"
  }
}

output "default_sg_add_description" { #출력
  description = "default_sg_add_description"
  value = aws_security_group.default_sg_add.ingress
}
/*
variable "sg_list" {
  type        = map
  default     = {
    "ssh_sg":22, "web_sg":80,"was_sg":8009
  }
}
resource "aws_security_group" "default_sg_add" {
  for_each = var.sg_list
  ingress {
    description = each.key
    from_port   = each.value
    to_port     = each.value
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
    Name = "${each.key}"
  }
}


output "default_sg_add_description" { #출력
  description = "default_sg_add_description"

  value = [ for sg in aws_security_group.default_sg_add : sg.id ]
  
}
output "default_sg_add_to_port" { #출력
  description = "default_sg_add_to_port"
  value = [ for sg_name in aws_security_group.default_sg_add : sg_name.ingress.*.to_port  ]
}
*/



/*


resource "aws_instance" "app_server" { #리소스
  ami           = var.app_server_ami #이미지명 > 변수로 만듬
  instance_type = var.app_server_in_type
  vpc_security_group_ids = ["sg-02567aade589e3c60"]
  key_name = "ec01"
  for_each = toset(var.server_names) # 선언한 server_names 를 가져와서 값만큼 반복
  tags = {
    Name = "${each.value}"
  }
}

output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [ for server in aws_instance.app_server : server.public_ip ]
}
*/

#내 기본 VPC에 있는 기본 보안그룹이름 : sg-02567aade589e3c60

/*
1. 반복문
  1) count 그냥 카운트의 수만큼 반복 예제는 두번반복
    resource "aws_instance" "app_server" { #리소스
      count = 2 #카운트 속성 반복갯수
      ami           = var.app_server_ami #이미지명 > 변수로 만듬
      instance_type = var.app_server_in_type
      vpc_security_group_ids = ["sg-02567aade589e3c60"] #resource "aws_security_group" "ec2_allow_rule" 를 가져와서 설정해준다
      key_name = "ec01"
      tags = {
        Name = "web${count.index}"
      }
    }
    output "app_server_public_ip" { #출력
      description = "AWS_Public_Ip"
      value = aws_instance.app_server[*].public_ip # list 형식은 * 로 모두불러올수있다.
    }





  2) foreach
    - 변수의 값을 가져와서 반복하게 하고 속성에 for_each 를 추가하면된다
    variable "server_names" {
      type        = list(any)
      description = "create EC2 server with three names"
      default     = ["web01", "web02"]
    }

    resource "aws_instance" "app_server" { #리소스
      ami           = var.app_server_ami #이미지명 > 변수로 만듬
      instance_type = var.app_server_in_type
      vpc_security_group_ids = ["sg-02567aade589e3c60"]
      key_name = "ec01"
      for_each = toset(var.server_names) # 선언한 server_names 를 가져와서 값만큼 반복
      tags = {
        Name = "${each.value}"
      }
    }



    output "app_server_public_ip" { #출력
      description = "AWS_Public_Ip"
      value = [ for server in aws_instance.app_server : server.public_ip ] #for_each 방식은 리턴이 키벨류 형식이라 * 로 불러올수가 없다.
    }
*/