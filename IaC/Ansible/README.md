# Ansible
	Ansible은 스토리지, 서버 및 네트워킹을 자동화하는 구성 관리 플랫폼
	Ansible을 사용하여 이러한 구성 요소를 구성하면 어려운 수동 반복 작업을 자동화 가능

 1. 앤서블 구성요소
```
    (1) Ansible Control Node
	앤서블을 실행하는 노드입니다. /usr/bin/ansible이나 /usr/bin/ansible-playbook 명령을 이용하여 제어 노드에서 관리 노드들을 관리
	앤서블이 설치 되어 있으면 노트북이나, 서버급 컴퓨터를 제어 노드로 이용
    (2) Managed Node
	앤서블로 관리되는 서버를 매니지드 노드라고 한다. 
	매니지드 노드에는 앤서블이 설치 되지 않는다.
    (3) Inventory (host file)
	매니지드 노드 목록을 인벤토리라고 한다. 
	인벤토리는 각 매니지드 노드에 대한 IP 주소, 호스트 정보, 변수와 같은 정보를 지정할 수 있다.
    (4) Module
	앤서블이 실행하는 코드 단위
	각 모듈은 데이터베이스 처리, 사용자 관리, 네트워크 장치 관리 등 다양한 용도로 사용
	단일 모듈을 호출하거나 플레이북에서 여러 모듈을 호출 할 수도 있다.
    (5) Playbook
	순서가 지정된 작업 목록이 저장되어 지정된 작업을 해당 순서로 반복적으로 작업을 실행할 수 있다. 
```

2. 앤서블 설치
```
    centos8 기준
    (1) Managed Node
	SSH 설정
    (2) Control Node
	dnf -y install centos-release-ansible-29
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SIG-ansible-29.repo
	dnf --enablerepo=centos-ansible-29 -y install ansible

  ubuntu 기준
  sudo apt update
  sudo apt install -y software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible
  3) 인벤토리	
    (1) 기본 인벤토리
	/etc/ansible/hosts

    (2) 커스텀 인벤토리
	앤서블 명령어를 실행할 때 -i 옵션으로 파일 지정 가능

    (3) yml 파일 형식
  4) 플레이북
    (0) 실행 명령어
	ansible-playbook  -i  인벤토리파일경로  플레이북파일경로

    (1) 리눅스 명령어 실행
- name: 이름
  shell: |  
    명령어
  become: yes

    (2) 파일 복사
- name: "copy file"
  copy:
    src: 원본 파일
    dest: 매니지드노드의파일경로

  4) 없는 모듈 설치
	ansible-galaxy collection install community.mysql
	https://docs.w3cub.com/ansible~2.10/collections/community/mysql/mysql_query_module

```

```
ssh root@192.168.179.110 #하면 암호를 물어본다
컨트롤 node key 를 생성한다

ssh-keygen
ssh-copy-id root@192.168.179.110
>yes
- 매니지드노드의 아이피
> 암호입력(매니지드노드의 암호)
```
> 기본적인 inventory , playbook 구조

> 템플릿 위치는 사용자마다 다를수있다
```bash
명령어 실행위치
├── inventory
│   └── hosts.yaml
│
└── playbook
    ├── web
    │    │── template
    │    │     ├── 설정파일
    │    │     └── 코드파일
    │    ├── web-install.yaml
    │    ├── web-config.yaml
    │    └── web-start.yaml
    ├── was
    │    │── template
    │    │     ├── 설정파일
    │    │     └── 코드파일
    │    ├── was-install.yaml
    │    ├── was-config.yaml
    │    └── was-start.yaml
    └── db
         │── template
         │     └── rds.sql
         ├── db-install.yaml
         ├── db-config.yaml
         └── db-start.yaml
#ansible-playbook -i inventory/hosts.yaml playbook/db/db-install.yaml
``` 
1. <a href="./ex01">3tir 아키텍쳐 실습 (nginx + flask + mysql)</a>
 
2. <a href="./ex00">3tir 아키텍쳐 실습 (apache + tomcat + mysql)</a>