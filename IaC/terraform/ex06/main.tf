provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage = 8 #디스크용량
  engine = "mysql"
  engine_version = "5.7.39"
  instance_class = "db.t2.micro"
  availability_zone = "ap-northeast-2c"
  username = "admin"
  password = "qwer1234"
  db_name = "yoskr_db"
  port = "3306"
  skip_final_snapshot = true
  apply_immediately= true #수정사항 즉시적용
  db_subnet_group_name = aws_db_subnet_group.default.id #서브넷 연결할곳
  vpc_security_group_ids = [ aws_security_group.default_sg_add["db_sg"].id ]
  publicly_accessible = true #퍼블릭엑서스 여부
}

/*
resource "aws_instance" "app_server" {
  for_each = toset(var.app_list)
  ami           = "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  key_name = "ec01"
  subnet_id = aws_subnet.my-subnet["a"].id #서브넷아이디(가용영역)
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = each.value == "web" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["web_sg"].id] : each.value == "was" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["was_sg"].id] : [aws_security_group.default_sg_add["ssh_sg"].id]
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
*/