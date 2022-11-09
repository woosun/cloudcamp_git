# Ansible 변수 조건문 반복문


1. 변수
+ 변수 타입
```yaml
	vars:
	  string_var: "A"
	  number_var: 1
	  boolean_var: "yes"
	  list_var:
	    - A
	    - B
	    - C
	  dict_var:
	      key_a: "val_a"
	      key_b: "val_b"
	      key_c: "val_c"
```
+ 변수 만드는 법
```yaml
	- name: test var
	  vars_files:
	    - vars/main.yml
	  vars:
	    key1: value1
```

+ 변수 사용하는 법 (jinja2 문법)
+ 변수는 {{ }} 쌍중괄호사이에
+ {{}} 사용할때는 쌍따옴표 또는 홑 따옴표로 감싸줘야함


2. 반복문
> 모듈에 with_items: 선언
```yaml
	with_items:
	  - apple
	  - banana
	  - kiwi

	사용할 때는 {{ item }} 으로 사용
```

3. 조건문

> 모듈에 when: 선언
```yaml
	vars:
	  switch: "on"
	tasks:
	  - debug:
	      msg: "hello switch on"
	    when: switch == "on"
	  - debug:
	      msg: "hello switch off"
	    when: switch == "off"
```


## 실습
> was_install.yaml 파일
- wget, java 반복문으로 변경 변수로 설정
- tomcat 버전 변수로 설정
- tomcat 파일이 존재하면 압축풀게
- 반대쪽에 폴더가 있으면 무부 안하고 없으면 mv하게
```yaml
- hosts: ["192.168.179.120"]
  vars_files:
    - vars/was_install_var.yml
  tasks:
  - name: "Update yum"
    shell: |
      yum update -y
    become: yes
  - name: "Insatll Prog"
    shell: |
      yum -y install "{{ item }}"
    with_items:
      - "{{ was_install_apps }}"
  - name: "Download Tomcat"
    shell: |
      wget  -O /tmp/apache-tomcat-{{ was_tomcat_var }}.tar.gz https://dlcdn.apache.org/tomcat/tomcat-9/v{{ was_tomcat_var }}/bin/apache-tomcat-{{ was_tomcat_var }}.tar.gz
    become: yes
  - name: "Check Download Tomcat"
    stat:
      path: "/tmp/apache-tomcat-{{ was_tomcat_var }}.tar.gz"
    register: down_tomcat
  - name: "Unarchive Tomcat"
    unarchive:
      src: "/tmp/apache-tomcat-{{ was_tomcat_var }}.tar.gz"
      dest: "/tmp"
      remote_src: True
    become: yes
    when: down_tomcat.stat.size > 0 
  - name: "Check Unarchive Tomcat"
    shell: |
      ls /tmp/apache-tomcat-{{ was_tomcat_var }}/
    register: result_arc
  - name: "Check already Tomcat"
    stat:
      path: "/usr/local/tomcat9/apache-tomcat-{{ was_tomcat_var }}/"
    register: result_dir
  - name: "Move Tomcat"
    shell: |
      mv /tmp/apache-tomcat-"{{ was_tomcat_var }}" /usr/local/tomcat9
    become: yes
    when: 
      - result_arc.stdout !=""  #아카이브가 제대로 풀렷는지
      - result_dir.stat.exists == false  #옴길곳이 비어있는지
      false
```

> was_config.yaml 파일
- wget, java 반복문으로 변경 변수로 설정
- tomcat 버전 변수로 설정

```yaml
- hosts: ["192.168.179.120"]
  vars_files:
    - vars/was_install_var.yml
  vars:
    project_path: "yoskr"
  tasks:
  - name: "Replace server.xml file"
    template:
      src: config/server.xml.j2
      dest: /usr/local/tomcat9/conf/server.xml
    become: yes
  - name: "Create Context Dir"
    shell: |
      mkdir /usr/local/tomcat9/webapps/{{ project_path }}
    become: yes

  - name: "Copy jsp file"
    copy:
      src: config/test.jsp
      dest: /usr/local/tomcat9/webapps/{{ project_path }}/test.jsp
    become: yes

  - name: "Download mysql-connector"
    shell: |
      wget -O /tmp/{{ mysql-connector_var }}.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/{{ mysql-connector_var }}.tar.gz
    become: yes

  - name: "Unarchive mysql-connector"
    unarchive:
      src: "/tmp/{{ mysql-connector_var }}.tar.gz"
      dest: "/tmp"
      remote_src: True
    become: yes

  - name: "Copy mysql-connector"
    shell: |
      cp /tmp/{{ mysql-connector_var }}/*.jar /usr/local/tomcat9/lib/
    become: yes
```