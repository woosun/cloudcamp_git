variable "app_server_ami" {
  type = string
  default = "ami-068a0feb96796b48d"
}

variable "app_server_in_type" {
  type = string
  default = "t2.micro"
}

variable "server_names" {
    type        = list(any)
    description = "create EC2 server with three names"
    default     = ["web01", "web02"]
}