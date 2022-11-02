

#시큐리티그룹
resource "aws_security_group" "default_sg_add" {
  vpc_id = aws_vpc.my-vpc.id
  for_each = var.sg_list
  dynamic ingress {
    for_each = each.value
    content {
      description = each.key
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${each.key}"
  }
}