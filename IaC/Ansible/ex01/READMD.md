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
  3) 인벤토리	

```
- 실습
> Control Node 1대 1cpu 2gb
* 192.168.179.100
> Managed Node 3대 1cpu 2gb
* 192.168.179.110
* 192.168.179.120
* 192.168.179.130

- 컨트롤 노드가 매니지드 노드 접속할떄 암호없이 키로 접속할수 있게 셋팅한다.
- ssh-copy-id 는 자물쇠를 만들어 이것으로 잠궈둬라 하는 개념임
- 
```
ssh root@192.168.179.110 #하면 암호를 물어본다
컨트롤 node key 를 생성한다

ssh-keygen
ssh-copy-id root@192.168.179.110
>yes
- 매니지드노드의 아이피
> 암호입력(매니지드노드의 암호)
```
> Inventory 설정 yml 파일형식으로도 작성이 가능하므로 yml방식으로 한다.
```
cd /etc/ansible/
mkdir inventory
cd inventory
vi hosts.yaml
all:
  hosts: #모든 서버목록
    192.168.179.110:
    192.168.179.120:
    192.168.179.130:
  children:
    webservers:         #그룹이름
      hosts:            #그룹에 속하는 호스트
        192.168.179.110:
    wasservers:
      hosts:
        192.168.179.120:
    dbservers:
      hosts:
        192.168.179.130:
-m 모듈
-i 인벤토리
ansible -i hosts.yaml -m ping webserver
```
> playbook
- 순서가 지정된 작업 목록이 저장되어 지정된 작업을 해당 순서로 반복적으로 작업을 실행할 수 있다. 
```
- name: 이름
  shell: |  
    명령어
  become: yes
```
> 리눅스 명령어 실행
```
cd /etc/ansible/
mkdir playbook
cd playbook
mkdir httpd
vi httpd-install.yaml
- hosts: ["192.168.179.110","192.168.179.120"]
  tasks:
  - name: "Install httpd server"
    shell: |
      yum update -y
      yum install -y httpd net-tools
    become: yes
  - name: "Start httpd server"
    shell: |
      systemctl restart httpd
    become: yes
```
> 실행 : ansible-playbook  -i  인벤토리파일경로  플레이북파일경로
 - ansible-playbook -i inventory/hosts.yaml playbook/httpd/httpd-install.yaml
> 파일복사
```
vi httpd-install.yaml 수정해서 파일추가한다.
 - name: "Copy file"
    copy:
      src: "template/ansible.html" #playbook밑에 template폴더생성해서 ansible.html파일하나만듬
      dest: "/var/www/html/ansible.html"

```

```
mkdir playbook/mysql/
vi playbook/mysql/mysql-install.yaml
- hosts: ["192.168.179.130"]
  tasks:
  - name: "Install mysql server"
    shell: |
      yum update -y
      yum remove mysql-server
      rm -rf /var/lib/mysql
      systemctl stop firewalld
      systemctl disable firewalld
      setenforce 0
      yum install -y mysql-server
    become: yes

  - name: "Install python"
    shell: |
      yum install -y python3 python3-pip
    become: yes

  - name: "Install pymysql"
    pip:
      name: pymysql

  - name: test mysql_secure_installation
    mysql_secure_installation:
      login_password: 
      new_password: qwer1234
      user: root
      login_host: localhost
      hosts: "%"

  - name: "mysql config"
    mysql_user:
      user: "root"
      password: "qwer1234"
      host: "%"
      login_unix_socket: /var/lib/mysql/mysql.sock
      check_implicit_admin: true

  - name: "Start mysql server"
    shell: |
      systemctl restart mysqld
    become: yes

ansible-playbook -i inventory/hosts.yaml playbook/mysql/mysql-install.yaml
```



https://docs.w3cub.com/ansible~2.10/collections/community/mysql/mysql_query_module


윈도우에 엔서블 설치
https://www.lesstif.com/ansible/windows-ansible-95879887.html