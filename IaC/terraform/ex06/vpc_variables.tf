#서브넷 생성
variable "my-vpc-subnet" {
  type        = map
  default     = {
    "a" : "200.200.10.0/24"
    "c" : "200.200.30.0/24"
  }
}