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






 - 보안그룹 설정
#



 - 키포인트정리
 - 이중반복문 처리 for_each dynamic for_each



#




4. 