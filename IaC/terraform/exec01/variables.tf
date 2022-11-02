variable "ssh_sg" {
  type        = map
  default     = {
    "22" : ["0.0.0.0/0"]
  }
}
variable "web_sg" {
  type        = map
  default     = {
    "80" : ["0.0.0.0/0"]
    "443" : ["0.0.0.0/0"]
  }
}
variable "was_sg" {
  type        = map
  default     = {
    "8080" : ["200.200.10.0/24","200.200.20.0/24"]
    "8009" : ["200.200.10.0/24","200.200.20.0/24"]
  }
}
variable "sg_list" {
  type    = set(string)
  default     = [
    "ssh_sg", "web_sg","was_sg"
  ]
}