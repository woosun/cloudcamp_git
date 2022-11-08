### 일단외우자 테라폼 명령어
    terraform init	초기화
    terraform validate	검증
    terraform plan	계획
    terraform apply	적용
    terraform destroy	제거
    terraform show	상태 확인

실습 3티어 만들기
```
ec2 nginx
	프로비전 : 테라폼
	구성: 엔서블
ec2 flask
	프로비전 : 테라폼
	구성: 엔서블

rds
	프로비전 : 테라폼
	구성: 엔서블
```

> 기본구성
+ 테라폼 설치
+ 앤서블 설치
+ ~ 에 AWS 키파일 저장 및 chmod 600 권한변경
