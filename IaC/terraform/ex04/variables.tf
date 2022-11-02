#서브넷 생성
variable "my-vpc-subnet" {
  type        = map
  default     = {
    "a" : "200.200.10.0/24"
    "c" : "200.200.30.0/24"
  }
}

#보안그룹 생성
variable "sg_list" {
  type = map
  default = {
    "ssh_sg" : ["22"],
    "web_sg" : ["80","443"],
    "was_sg" : ["8080","8009"]
  }
  
}