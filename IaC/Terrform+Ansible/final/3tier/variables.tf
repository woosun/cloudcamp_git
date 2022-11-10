variable "image_id" {} #ec2 생성시 사용할 리눅스
variable "key_name" {} #내 ec2접속키
variable "security_groups" {}
variable "vpc_id" {}
variable "subnets" {}


variable "my-db" {
  type        = map
  default     = {
    "DB_USER" : "admin"
    "DB_DBNAME" : "yoskr_db"
    "MYSQL_ROOT_PASSWORD" : "qwer1234"
  }
}