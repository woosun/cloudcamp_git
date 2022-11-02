# 테라폼 2일차 반복문 제어문
### 일단외우자 테라폼 명령어
    terraform init	초기화
    terraform validate	검증
    terraform plan	계획
    terraform apply	적용
    terraform destroy	제거
    terraform show	상태 확인

# Terraform 제어문
## 1) 반복문
#### (0) Set와 Map형 변수
	set : 유일한 값의 요소들로 이루어진 list
		ex) [1, 2, 3]

	map : Key-Value 형식의 데이터, key 값은 string이여야함
		ex) { k : v, k2 : v2 }


### (1) count를 이용한 방식
    resource "aws_instance" "app_server" { #리소스
      count = 2 #카운트 속성 반복갯수
      ami           = var.app_server_ami #이미지명 > 변수로 만듬
      instance_type = var.app_server_in_type
      vpc_security_group_ids = ["sg-02567aade589e3c60"] #resource "aws_security_group" "ec2_allow_rule" 를 가져와서 설정해준다
      key_name = "ec01"
      tags = {
        Name = "web${count.index}"
      }
    }
    output "app_server_public_ip" { #출력
      description = "AWS_Public_Ip"
      value = aws_instance.app_server[*].public_ip # list 형식은 * 로 모두불러올수있다.
    }

------------------------------------------------------------

###  (2) foreach

    - 변수의 값을 가져와서 반복하게 하고 속성에 for_each 를 추가하면된다
    variable "server_names" {
      type        = list(any)
      description = "create EC2 server with three names"
      default     = ["web01", "web02"]
    }

    resource "aws_instance" "app_server" { #리소스
      ami           = var.app_server_ami #이미지명 > 변수로 만듬
      instance_type = var.app_server_in_type
      vpc_security_group_ids = ["sg-02567aade589e3c60"]
      key_name = "ec01"
      for_each = toset(var.server_names) # 선언한 server_names 를 가져와서 값만큼 반복
      tags = {
        Name = "${each.value}"
      }
    }

    output "app_server_public_ip" { #출력
      description = "AWS_Public_Ip"
      value = [ for server in aws_instance.app_server : server.public_ip ] #for_each 방식은 리턴이 키벨류 형식이라 * 로 불러올수가 없다.
    }
 

### 실습  3개의 보안그룹 생성
*  sg_list 에 ssh : 20 , web :80 , was : 8009 여는 보안그룹 각각 생성
  ###
    variable "sg_list" {
    type        = map
    default     = {"ssh_sg":22, "web_sg":80,"was_sg":8009}
    /*
    each.key , each.value 키벨류형식으로 출력
    */
    }
    resource "aws_security_group" "default_sg_add" {
    for_each = var.sg_list
    ingress {
        description = each.key
        from_port   = each.value
        to_port     = each.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
    output "default_sg_add_description" { #출력
    description = "default_sg_add_description"
    value = [ for sg_name in aws_security_group.default_sg_add : sg_name.ingress.*.description  ]
    }
    output "default_sg_add_to_port" { #출력
    description = "default_sg_add_to_port"
    value = [ for sg_name in aws_security_group.default_sg_add : sg_name.ingress.*.to_port  ]
    }

* 실습2 하나의 보안그룹에 여러개의 포트를 지정하라


  ###



* 실습 3
1. VPC생성 : a,c 가용영역에 각 서브넷을 생성
2. ssh_sg : 0.0.0.0/0 에 대해 22번 포트 허용
3. web_sg : 0.0.0.0/0 에 대해 80,443번 포트 허용
4. was_sg : a,c가용영역에 대해 8080.8009
5. EC2생성 :
   - web(ec2) : ssh_sg , web_sg
   - was(ec2) : ssh_sg , was_sg
## 2) 조건문

