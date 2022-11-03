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

## 실습
+ nginx ec2
+ gunicon ec2
+ mysql rds
+ 3개연결
+ VPC 생성하여