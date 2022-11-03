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