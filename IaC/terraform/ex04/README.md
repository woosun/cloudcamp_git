### 일단외우자 테라폼 명령어
    terraform init	초기화
    terraform validate	검증
    terraform plan	계획
    terraform apply	적용
    terraform destroy	제거
    terraform show	상태 확인
    
# 실습 3

1. VPC생성 : a,c 가용영역에 각 서브넷을 생성
2. ssh_sg : 0.0.0.0/0 에 대해 22번 포트 허용
3. web_sg : 0.0.0.0/0 에 대해 80,443번 포트 허용
4. was_sg : a,c가용영역에 대해 8080.8009
5. EC2생성 :
   - web(ec2) : ssh_sg , web_sg
   - was(ec2) : ssh_sg , was_sg

# 풀이

# 1. VPC 및 서브넷 생성 cdir_block = each.value
##
 -  변수선언
#
    variable "my-vpc-subnet" {
    type        = map
    default     = {
        "a" : "200.200.10.0/24"
        "c" : "200.200.30.0/24"
    }
- 서브넷 설정
#
      resource "aws_subnet" "my-subnet" {
         for_each = var.my-vpc-subnet
         vpc_id     = aws_vpc.my-vpc.id
         cidr_block = each.value
         availability_zone = "ap-northeast-2${each.key}"
         map_public_ip_on_launch = true
         tags = {
            Name = "my-subnet-${each.key}"
         }
      }
      output "my-subnet-ids" {
         value = [for my-subnet in aws_subnet.my-subnet: my-subnet.id]
      }
 - 키포인트 정리
 - for_each = var.my-vpc-subnet #변수를 반복시켜 변수의 배열만큼 서브넷생성
 - Name = "my-subnet-${each.key}" #변수의 이름을 지정
 - cdir_block = each.value
 - availability_zone = "ap-northeast-2${each.key}"

# 2. 보안그룹
 - 변수선언
#
      variable "sg_list" {
         type = map
         default = {
            "ssh_sg" : {"22" : ["0.0.0.0/0"]},
            "web_sg" : {"80" : ["0.0.0.0/0"],"443" : ["0.0.0.0/0"]},
            "was_sg" : {"8080" : ["200.200.10.0/24", "200.200.30.0/24"],"8009" : ["200.200.10.0/24", "200.200.30.0/24"]},
         }
      }
 - 보안그룹 설정
#
      resource "aws_security_group" "default_sg_add" {
         vpc_id = aws_vpc.my-vpc.id
         for_each = var.sg_list
         dynamic ingress {
            for_each = each.value
            content {
               description = each.key
               from_port   = ingress.key
               to_port     = ingress.key
               protocol    = "tcp"
               cidr_blocks = ingress.value
            }
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
 - 키포인트정리
 - 이중반복문 처리 for_each dynamic for_each
 - 변수의 map 구조 잘보기


#




# 3. EC2생성 :
   - web(ec2) : ssh_sg , web_sg #추후 반복문을 배우면 적용 지금은 모든 보안그룹 설정
   - was(ec2) : ssh_sg , was_sg #추후 반복문을 배우면 적용 지금은 모든 보안그룹 설정
- 변수선언
#
      variable "app_list" {
         type = list
         default = [ "web","was" ]
      }
- EC2생성
#
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

- 키포인트정리
- for_each = toset(var.app_list) 리스트형식이라 toset으로 긁어옴

### 각 업무별로 분리하는게 좋다

- vpc.tf # VPC관련된 부분만 모아둠
- vpc_variables.tf # VPC 변수만 모아둠
- sg.tf # 보안그룹 관련된 부분만 모아둠
- sg_variables.tf # 보안그룹에서 사용하는 변수만 모아둠
- main.tf 
- variables.tf
- ※ terraform이 알아서 실행될수 있도록 왠만한 값들은 모두 변수에서 참조해서 작성해야 꼬이지 않는다


## EC2생성 보안그룹 설정 바꾸기.

- 기존 모든 보안그룹 다가져오기
- vpc_security_group_ids = [ for sg in aws_security_group.default_sg_add: sg.id ]

- 변경 
- vpc_security_group_ids = each.value == "web" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["web_sg"].id] : each.value == "was" ? [ aws_security_group.default_sg_add["ssh_sg"].id, aws_security_group.default_sg_add["was_sg"].id] : [aws_security_group.default_sg_add["ssh_sg"].id]