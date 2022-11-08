```
- 실습 셋팅구성
> Control Node 1대 1cpu 2gb
* 192.168.179.100
> Managed Node 3대 1cpu 2gb
* 192.168.179.110 # ㅈ듀
* 192.168.179.120
* 192.168.179.130
```
# 변수
1. 변수 타입
```
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
2. 변수 만드는 법
```
	- name: test var
	  vars_files:
	    - vars/main.yml
	  vars:
	    key1: value1
```

3. 변수 사용하는 법 (jinja2 문법)
+	변수는 {{ }} 쌍중괄호사이에
+	{{}} 사용할때는 쌍따옴표 또는 홑 따옴표로 감싸줘야함
+	변수를 템플릿을 통해서 다른파일내용도 바꿔서 보낼수있음
+	변수를 별도 파일로 만들어서 관리하면 좋음
+   원래는 폴더안에 main.yaml파일로 만들어서 관리한다.
```
- hosts: ["192.168.179.130"]
#  vars: #변수로 선언해도 되고
#    var1: "hello ansible"
  vars_files: #변수파일로 불러와도 되고
    - vars/main.yml
#   - vars/main2.yml #변수를 여러개 선언해도 되고
#   - vars/main3.yml
#   - vars/main4.yml
  tasks:
  - name: "var test"
    debug:
      msg: 'var1 : {{ var1 }}'
  #이건 origin.txt 파일 그대로 복사한다.
  - name: "copy"
    copy:
      src: origin.txt
      dest: /tmp/copy.txt
  # 이건 origin.txt 변수값을 집어넣는다.
  - name: "template"
    template:
      src: origin.txt
      dest: /tmp/template.txt
```



# 반복문
> 모듈에 with_items: 선언
```
	with_items:
	  - apple
	  - banana
	  - kiwi

	사용할 때는 {{ item }} 으로 사용
```
- 반복문 1
```
- hosts: ["192.168.179.130"] 
  tasks:
  - name: "loop test"
    debug:
      msg: '{{ item }}'
    with_items:
      - apple
      - banana
      - kiwi
```
- 반복문 2
```
hosts: ["192.168.179.130"] 
  vars:
    list1:
      - apple
      - banana
      - kiwi
  tasks:
  - name: "loop test"
    debug:
      msg: "{{ item }}"
    with_items:
      - "{{ list1 }}" #변수로 불러올수도있고 변수파일을 불러올수도 있다.
```
# 조건문
> 모듈에 when: 선언
```
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

# <a href="./ex02">소스보기 < Click </a>
- 조건문은 자신의 상태에 따라 분기처리에 사용할수있다.
- 상태모듈 https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_stats_module.html