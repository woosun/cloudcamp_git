provider "aws" { 
  region  = "ap-northeast-2" #리전명
}
resource "aws_instance" "app_server" { #리소스
  ami= "ami-068a0feb96796b48d"
  instance_type = "t2.micro"
  #
  provisioner "file" {
    source      = "was.sh"
    destination = "/tmp/was.sh"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ec01.pem")
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/was.sh",
      "sudo /tmp/was.sh"
    ]
  }
  vpc_security_group_ids = [ "sg-02567aade589e3c60" ] 
  key_name = "ec01"
  associate_public_ip_address = true #공용아이피주소
  tags = {
    Name = "web_server"
  }
}
output "app_server_public_ip" { #출력
  description = "AWS_Public_Ip"
  value = aws_instance.app_server.public_ip
}