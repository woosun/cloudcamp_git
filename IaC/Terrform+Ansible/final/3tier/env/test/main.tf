provider "aws" {
  region = "ap-northeast-2"
}

module "test" {
  source = "../../"

  key_name = "ec01"
  image_id = "ami-068a0feb96796b48d"
  security_groups = ["sg-0a204e6226655f5e2"]
  subnets = [ "subnet-096e3bc5b9f23376d", "subnet-0dfe685c08daa5600"]
  vpc_id = "vpc-08e5af456e8e80c6d"
}

