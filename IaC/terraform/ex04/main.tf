provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_instance" "app_server" {
  for_each = toset(var.app_list)
  ami           = "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  key_name = "ec01"
  subnet_id = aws_subnet.my-subnet["a"].id #서브넷아이디(가용영역)
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = [ for sg in aws_security_group.default_sg_add: sg.id ]
  tags = {
    Name = "${each.value}"
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}
output "my-subnet-Name" {
    value = [for my-subnet in aws_subnet.my-subnet: my-subnet.tags.Name]
}
output "my-sg-Name" {
    value = [for my-sg in aws_security_group.default_sg_add: my-sg.tags.Name]
}











/*
resource "aws_security_group_rule" "allow_inbound_traffic_1" {
  count = "${local.nat_instance ? 1 : 0}"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  cidr_blocks = ["${aws_subnet.private_app_1.cidr_block}"]
  security_group_id = "${aws_security_group.access_via_nat.id}"
}


*/