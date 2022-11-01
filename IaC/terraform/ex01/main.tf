terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-northeast-2" #리전명
}

resource "aws_instance" "app_server" {
  ami           = "ami-068a0feb96796b48d" #이미지명
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}