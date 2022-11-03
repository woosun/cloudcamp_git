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

resource "null_resource" "db_setup" {
  depends_on = [aws_db_instance.mysql_db ] #db 인스턴스의 mysql_db가 생성이 되면 실행하는 리소스이다 라는뜻
  
  provisioner "local-exec" {
    command = "mysql -u admin --password=qwer1234 -h ${aws_db_instance.mysql_db.address} --database=yoskr_db < ./rds.sql "
  }
}

resource "aws_instance" "app_server" {
  for_each = toset(var.app_list)
  ami           = "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  key_name = "ec01"
  subnet_id = each.value == "web" ? aws_subnet.my-subnet["a"].id :  aws_subnet.my-subnet["c"].id 
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = each.value == "web" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["web_sg"].id] : each.value == "was" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["was_sg"].id] : [aws_security_group.default_sg_add["ssh_sg"].id]
  user_data = <<-EOF
  #! /bin/bash
  export DB_HOST=${aws_db_instance.mysql_db.address}
  export DB_USER=admin
  export MYSQL_ROOT_PASSWORD=qwer1234
  export DB_DBNAME=yoskr_db
  sudo apt update -y
  sudo apt install software-properties-common
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt -y install python3.9 python3.9-distutils
  sudo curl https://bootstrap.pypa.io/get-pip.py -o /apps/get-pip.py
  sudo python3.9 /apps/git-pip.py
  sudo apt -y install git
  git clone https://github.com/woosun/backend.git
  cd ./backend/
  pip3 install -r ./requirements.txt
  gunicorn --bind 0.0.0.0:8000 wsgi:app &
  EOF
  tags = {
    Name = "${each.value}"
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}