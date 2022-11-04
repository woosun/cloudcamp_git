### 일단외우자 테라폼 명령어
    terraform init	초기화
    terraform validate	검증
    terraform plan	계획
    terraform apply	적용
    terraform destroy	제거
    terraform show	상태 확인
# Terraform 리눅스 명령어 실행
- 연습을 위해 기본적인 EC를 실행후
- 아래의 소스코드처럼 유저데이타로 명령어를 실행할수 있다
- 직접 코드를 작성해도되고 쉘스크립트를 실행하게 할수도 있다.

```BASH
provider "aws" { 
  region  = "ap-northeast-2" #리전명
}
resource "aws_instance" "app_server" { #리소스
  ami= "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "sg-02567aade589e3c60" ] 
  key_name = "ec01"
  associate_public_ip_address = true #공용아이피주소
  #유저데이타로 아파치를 설치하고 실행한다.
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update - y
  sudo apt install -y apache2
  sudo systemctl restart apache2
  EOF
  tags = {
    Name = "web_server"
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = aws_instance.app_server.public_ip
}
```
## Terraform 프로비저너 배우기

### provisioner
> local-exec #지금 작동중인 컴퓨터(즉 테라폼이 실행되는 컴퓨터에서 실행)
```
resource "null_resource" "db_setup" {
  depends_on = [aws_db_instance.mysql_db ] #db 인스턴스의 mysql_db가 생성이 되면 실행하는 리소스이다 라는뜻
  
  provisioner "local-exec" { #로컬에서 실행한다.
    command = "mysql -u admin --password=qwer1234 -h ${aws_db_instance.mysql_db.address} --database=yoskr_db < ./rds.sql "
  }
}
```
> file #파일을 복사
```
provisioner "file" {
  source      = "was.sh"
  destination = "/tmp/was.sh"
}
```
> remote-exec #원격컴퓨터에서 실행
```
provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/was.sh",
    "sudo /tmp/was.sh"
  ]
}
```
## 로컬에 있는 파일을 생성하는 리소스를 보자


## 실습
1. nginx ec2
2. gunicon ec2
3. mysql rds
4. 3개연결
5. VPC 생성하여
>>설치할떄는 거꾸로 하는게 좋다.


5. VPC 생성
```

```

3. mysql rds 만들기
>  - db 생성을 위한 db 서브넷 별도생성
>  - db 보안그룹 생성
>  - db rds 생성
>  - 테라폼 환경에서 db 접속하여 테이블 생서 mysql -u admin --password=qwer1234 -h 주소 --database=yoskr_db < c:\rds.sql
>  - mysql 다운받고 c:에 풀고 path 환경변수에 등록 C:\mysql\bin
2. gunicon ec2 생성
>  파이썬 설치 및 셋팅설정
```
#ubuntu 18.04
#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install python3.9 python3.9-distutils
sudo mkdir /apps
sudo curl https://bootstrap.pypa.io/get-pip.py -o /apps/get-pip.py
sudo python3.9 /apps/get-pip.py
sudo apt -y install git
git clone https://github.com/woosun/backend.git
cd ./backend/
sudo pip install -r ./requirements.txt
```
> DB접속을 위한 환경변수

```
"sudo echo 'export DB_HOST=${aws_db_instance.mysql_db.address}' >> /tmp/env_db_host",
"sudo echo 'export DB_USER=admin' >> /tmp/env_db_host",
"sudo echo 'export DB_DBNAME=yoskr_db' >> /tmp/env_db_host",
"sudo echo 'export MYSQL_ROOT_PASSWORD=qwer1234' >> /tmp/env_db_host",
```
> 실행 쉘스크립트
```
#!/bin/bash
cd ./backend/
source /tmp/env_db_host
gunicorn --bind=0.0.0.0:8000 wsgi:app
```

> 안되면 ssh로 접속해서 각각 실행해본다.


1. nginx ec2 생성

```
resource "aws_instance" "app_server" {
  for_each = toset(var.app_list)
  ami           = "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  key_name = "ec01"
  subnet_id = aws_subnet.my-subnet["a"].id
  associate_public_ip_address = true #공용아이피주소
  vpc_security_group_ids = [ 
    aws_security_group.default_sg_add["ssh_sg"].id, 
    aws_security_group.default_sg_add["web_sg"].id
  ]

  provisioner "file" {
    source = "web.sh"
    destination = "/tmp/web.sh"
  }
  provisioner "file" {
    source      = "web_start.sh"
    destination = "/tmp/web_start.sh"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ec01.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo 'export WAS_ADDR=${aws_instance.app_server["was"].private_ip}' >> /tmp/env_was_host",
      "sudo echo 'export WEB_PUB_ADDR=${self.public_ip}' >> /tmp/env_was_host",
      "chmod +x /tmp/web_start.sh",
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh",
      "nohup /tmp/web_start.sh &",
      "sleep 1"
    ]
    
  }
  tags = {
      Name = "${each.value}"
  }
}
```









최종소스
```
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

  provisioner "file" {
    source = each.value == "web" ? "web.sh" : "was.sh"
    destination = each.value == "web" ? "/tmp/web.sh" : "/tmp/was.sh"
  }
  provisioner "file" {
    source      = each.value == "web" ? "web_start.sh" : "was_start.sh"
    destination = each.value == "web" ? "/tmp/web_start.sh" : "/tmp/was_start.sh"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ec01.pem")
  }
  provisioner "remote-exec" {
    inline = each.value == "web" ? [
      "sudo echo 'export WAS_ADDR=${aws_instance.app_server["was"].private_ip}' >> /tmp/env_was_host",
      "sudo echo 'export WEB_PUB_ADDR=${self.public_ip}' >> /tmp/env_was_host",
      "chmod +x /tmp/web_start.sh",
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh",
      "nohup /tmp/web_start.sh &",
      "sleep 1"
    ] : [
      "sudo echo 'export DB_HOST=${aws_db_instance.mysql_db.address}' >> /tmp/env_db_host",
      "sudo echo 'export DB_USER=admin' >> /tmp/env_db_host",
      "sudo echo 'export DB_DBNAME=yoskr_db' >> /tmp/env_db_host",
      "sudo echo 'export MYSQL_ROOT_PASSWORD=qwer1234' >> /tmp/env_db_host",
      "chmod +x /tmp/was.sh",
      "sudo /tmp/was.sh",
      "chmod +x /tmp/was_start.sh",
      "nohup /tmp/was_start.sh &",
      "sleep 1"
    ]
   
  }
  tags = {
      Name = "${each.value}"
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = [for ec2 in aws_instance.app_server : ec2.public_ip ]
}
```