- 실습
> Control Node 1대 1cpu 2gb
* 192.168.179.100
> Managed Node 3대 1cpu 2gb
* 192.168.179.110
* 192.168.179.120
* 192.168.179.130

- 컨트롤 노드가 매니지드 노드 접속할떄 암호없이 키로 접속할수 있게 셋팅한다.
- ssh-copy-id 는 자물쇠를 만들어 이것으로 잠궈둬라 하는 개념임

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