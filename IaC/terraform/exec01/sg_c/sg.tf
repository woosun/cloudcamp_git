resource "aws_security_group" "default_sg_add" {
  vpc_id = aws_vpc.my-vpc2.id
  dynamic ingress {
    for_each = var.inbound_port
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_name}"
  }
}