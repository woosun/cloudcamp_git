#보안그룹 생성
variable "sg_list" {
  type = map
  default = {
    "ssh_sg" : {"22" : ["0.0.0.0/0"]},
    "web_sg" : {"80" : ["0.0.0.0/0"],"443" : ["0.0.0.0/0"]},
    "was_sg" : {"8000" : ["200.200.10.0/24", "200.200.30.0/24","221.162.65.184/32"]}
    "db_sg" : {"3306" : ["200.200.10.0/24", "200.200.30.0/24","221.162.65.184/32"]}
  }
}
