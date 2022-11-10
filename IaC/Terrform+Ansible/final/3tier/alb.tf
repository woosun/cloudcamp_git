resource "aws_alb" "gunicorn" {
  name            = "alb-gunicorn"
  internal        = true
  security_groups = "${var.security_groups}"
  subnets         = "${var.subnets}"
  tags = {
    Name = "gunicorn alb"
  }

  lifecycle { create_before_destroy = true }
}


resource "aws_alb_target_group" "gunicorn" {
  name     = "gunicorn-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = 30
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = { Name = "gunicorn Target Group" }
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.gunicorn.arn}"
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.gunicorn.arn}"
    type             = "forward"
  }
}


# alb web


resource "aws_alb" "nginx" {
  name            = "alb-nginx"
  internal        = true
  security_groups = "${var.security_groups}"
  subnets         = "${var.subnets}"
  tags = {
    Name = "nginx alb"
  }

  lifecycle { create_before_destroy = true }
}


resource "aws_alb_target_group" "nginx" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = 30
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = { Name = "nginx Target Group" }
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.nginx.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx.arn}"
    type             = "forward"
  }
}
