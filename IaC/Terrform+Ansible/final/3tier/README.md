# Ansible + Terrform + AWS + ES2 + RDS + ALB + AutoScaling


백앤드서버 git 


# 오토스케일링으로 늘어난 ec2에 앤서블 적용하는 방벙
1. 돈많으면 ami로 만들어둔다
2. 테라폼 user_data > 새로추가되는 ec2인스턴스에게 앤서블 실행하게 하는거
- ec2가 생성될떄 ansible 설치 및 실행
- 정적 인벤토리
4. 풀링방식
- ansible 명령어를 일정시간마다 계속 실행
- 동적 인벤토리
5. 이벤트 알람방식
- 알람을 받을 수 있는 서버가 켜져있고 알람을 받으면 ansible 실행
- 동적 인벤토리

> 실습 방향은 2번 방식으로 진행할예정이다

+ Terrform 으로 틀만들고 환경변수들을 ec2생성시 user_data에 넘겨서 Ansible을 실행하게 처리
+ Terrform 으로 ec는 로드벨런싱과 오토 스케일링 처리