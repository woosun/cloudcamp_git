variable "subnet_list" {
  type= map
  default = {
    "a" = "200.200.10.0/24"
    "c" = "200.200.30.0/24"
  }
}
variable "sg_list" {
  type = map
  default = {
    "ssh_sg" : {"22" : ["0.0.0.0/0"]},
    "web_sg" : {"80" : ["0.0.0.0/0"],"443" : ["0.0.0.0/0"]},
    "was_sg" : {"8080" : ["200.200.10.0/24", "200.200.30.0/24"],"8009" : ["200.200.10.0/24", "200.200.30.0/24"]},
  }
}
#인스턴스 변수생성
variable "app_list" {
  type = list
  default = [ "web","was" ]
}

variable "app_server_ami" {
  type = string
  default = "ami-068a0feb96796b48d"
}

variable "app_server_in_type" {
  type = string
  default = "t2.micro"
}