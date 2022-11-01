provider "aws" { 
  region  = "ap-northeast-2" #리전명
}

module "module_ec2_1" {
  source = "./ex01"
  app_server_ami ="ami-068a0feb96796b48d"
  app_server_in_type="t2.micro"
  app_server_name = "module_ec2_1"
}

module "module_ec2_2" {
  source = "./ex01"
  app_server_ami ="ami-068a0feb96796b48d"
  app_server_in_type="t2.micro"
  app_server_name = "module_ec2_2"
}

module "module_ec2_3" {
  source = "./ex01"
  app_server_ami ="ami-068a0feb96796b48d"
  app_server_in_type="t2.micro"
  app_server_name = "module_ec2_3"
}
#ex02/main.tf 에서 ex01에 있는 값만 가져와서 사용하는것을 만들어볼거임
#모듈개념