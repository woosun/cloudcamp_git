# 테라폼에 앤서블을 얹어보자


> 일단 앤서블 실습환경에 테라폼을 추가한다.

> 테라폼 설치
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```
> AWS CLI설치
```
sudo yum install -y zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
> AWS 설정적용
```
aws configure 명령어 실행
발급 받은 Access Key 내용 입력
Region은 ap-northeast-2
Default output format은 그냥 엔터
```
	terraform init	초기화
	terraform validate	검증
	terraform plan	계획
	terraform apply	적용
	terraform destroy	제거
	terraform show	상태 확인

ec2 하나생성
```
기존 테라폼 에서 ex02 에 모듈로 사용햇던 ex01로 만든다
~
├── anaconda-ks.cfg
├── ansible
│   └── inventory
│       └── ec2_host
├── key
├── terraform
│   ├── main.tf
│   ├── terraform.tfvars
│   └── variables.tf
└── web_install.yml

```

> ssh ubuntu@[EC2아이피] -i key
```
cat ansible/inventory/ec2_host
[all]
[EC2아이피] ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/root/key
```

> 실행
+ ansible-playbook -i ~/ansible/inventory/ec2_host ~/web_install.yml

> 테라폼에서 앤서블 실행하기


실습 3티어 만들기

ec2 nginx
	프로비전 : 테라폼
	구성: 엔서블
ec2 flask
	프로비전 : 테라폼
	구성: 엔서블

rds