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

1. mysql rds 만들기
>  - db 생성을 위한 db 서브넷 별도생성
>  - db 보안그룹 생성
>  - db rds 생성
>  - 테라폼 환경에서 db 접속하여 테이블 생서 mysql -u admin --password=qwer1234 -h 주소 --database=yoskr_db < c:\rds.sql
> > - mysql 다운받고 c:에 풀고 path 환경변수에 등록 C:\mysql\bin
2. gunicon ec2 생성
>  - 파이썬 설치
```
#ubuntu
#파이썬 설치
#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
#파이썬 설치
sudo apt -y install python3.9
#깃설치
sudo apt-get -y install git
sudo apt -y install git
alias python=python3
alias pip=pip3
#깃으로 클론떠오기
git clone https://github.com/woosun/backend.git
cd ./backend/
pip install -r /requirements.txt
gunicorn --bind 0.0.0.0:8000 wsgi:app
```






#사용자생성 및 nginx에게 user 그룹권한 주기
useradd -m user
usermod -a -G user nginx
chmod 750 /home/user