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


#web
  provisioner "local-exec" {
    count = each.value == "web" ? 1 : 0
    command = <<EOF
        echo '[web]' > web_inventory
        echo '${aws_instance.app_server["web"].public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/key' >> web_inventory
        echo 'export WAS_ADDR=${aws_instance.app_server["was"].private_ip}' > env_was_host
        echo 'export WEB_PUB_ADDR=${self.public_ip}' >> env_was_host
        sleep 10
        EOF
  }
  provisioner "local-exec" {
    count = each.value == "web" ? 1 : 0
    command = <<EOF
        ANSIBLE_HOST_KEY_CHECKING=False \
        ansible-playbook -i web_inventory /root/3tir/playbook/nginx-install.yaml
        EOF
  }

  provisioner "local-exec" {
    count = each.value == "web" ? 1 : 0
    command = <<EOF
        ANSIBLE_HOST_KEY_CHECKING=False \
        ansible-playbook -i web_inventory /root/3tir/playbook/nginx-config.yaml
        EOF
  }

#was
  provisioner "local-exec" {
    count = each.value == "web" ? 1 : 0
    command = <<EOF
        echo '[was]' >> was_inventory \
        echo '${aws_instance.app_server["was"].public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/key' >> was_inventory \
        echo 'export DB_HOST=${aws_db_instance.mysql_db.address}' >> config/env_db_host \
        echo 'export DB_USER=admin' >> config/env_db_host \
        echo 'export DB_DBNAME=yoskr_db' >> config/env_db_host \
        echo 'export MYSQL_ROOT_PASSWORD=qwer1234' >> config/env_db_host \
        sleep 10
        EOF
  }

  provisioner "local-exec" {
    count = each.value == "was" ? 1 : 0
    command = <<EOF
        ANSIBLE_HOST_KEY_CHECKING=False \
        ansible-playbook -i was_inventory /root/3tir/playbook/flask-install.yaml
        EOF
  }

  provisioner "local-exec" {
    count = each.value == "was" ? 1 : 0
    command = <<EOF
        ANSIBLE_HOST_KEY_CHECKING=False \
        ansible-playbook -i web_inventory /root/3tir/playbook/nginx-config.yaml
        EOF
  }

  tags = {
      Name = "${each.value}"
  }
}

output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}