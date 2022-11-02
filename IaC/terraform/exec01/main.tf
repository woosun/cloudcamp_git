provider "aws" { 
  region  = "ap-northeast-2" #리전명
}


resource "aws_security_group" "default_sg_add" {
  vpc_id = aws_vpc.my-vpc2.id
  for_each = var.sg_list
  dynamic ingress {
    for_each = each.value
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

resource "aws_instance" "app_server" {
  for_each = toset(var.app_list)
  ami           = var.app_server_ami
  instance_type = var.app_server_in_type
  key_name = "ec01"
  subnet_id = each.value == "web" ? aws_subnet.my-subnet["a"].id :  aws_subnet.my-subnet["c"].id 
  #서브넷아이디 web서버면 서브넷a was서버면 서브넷c 에 셋팅
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = each.value == "web" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["web_sg"].id] : [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["was_sg"].id] 
  tags = {
    Name = "${each.value}"
  }
}

output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}

