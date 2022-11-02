variable "sg_list" {
  type = map
  default = {
    "ssh_sg" : ["22"],
    "web_sg" : ["80","443"],
    "was_sg" : ["8080","8009"]
  }
  
}