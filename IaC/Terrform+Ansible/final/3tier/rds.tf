resource "aws_db_instance" "mysql_db" {
  allocated_storage = 8 #디스크용량
  engine = "mysql"
  engine_version = "5.7.39"
  instance_class = "db.t2.micro"
  availability_zone = "ap-northeast-2c"
  username = "${var.my-db.DB_USER}"
  password = "${var.my-db.MYSQL_ROOT_PASSWORD}"
  db_name = "${var.my-db.DB_DBNAME}"
  port = "3306"
  skip_final_snapshot = true
  apply_immediately= true #수정사항 즉시적용
  db_subnet_group_name = "default-vpc-08e5af456e8e80c6d" #서브넷 연결할곳
  vpc_security_group_ids = ["sg-0a9e1d878f3082f3b"]
  publicly_accessible = true #퍼블릭엑서스 여부
}

resource "null_resource" "db_setup" {
  depends_on = [ aws_db_instance.mysql_db ] #db 인스턴스의 mysql_db가 생성이 되면 실행하는 리소스이다 라는뜻
  provisioner "local-exec" {
        command = <<EOF
        mysql -u admin --password=qwer1234 -h ${aws_db_instance.mysql_db.address} --database=yoskr_db < /root/final/3tier/rds.sql
        EOF
  }
}
