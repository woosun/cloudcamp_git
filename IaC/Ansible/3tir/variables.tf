#인스턴스 변수생성
variable "app_list" {
  type = list
  default = [ "web" ]
}

variable "app_list1" {
  type = list
  default = [ "was" ]
}

#서브넷 생성
variable "my-db" {
  type        = map
  default     = {
    "DB_USER" : "admin"
    "DB_DBNAME" : "yoskr_db"
    "MYSQL_ROOT_PASSWORD" : "qwer1234"
  }
}