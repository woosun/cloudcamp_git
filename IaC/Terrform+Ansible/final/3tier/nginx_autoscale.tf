resource "aws_launch_configuration" "nginx" {
  depends_on = [ aws_db_instance.mysql_db ] #db 먼저만들고 실행하게 막는역활
  name_prefix     = "nginx-"
  image_id        = "${var.image_id}"
  instance_type   = "t2.micro"
  security_groups = "${var.security_groups}"
  key_name = "${var.key_name}"
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install software-properties-common git python3.9 python3.9-distutils
sudo mkdir /apps
sudo curl https://bootstrap.pypa.io/get-pip.py -o /apps/get-pip.py
sudo python3.9 /apps/get-pip.py
sudo pip install --ignore-installed ansible
git clone https://github.com/woosun/backend.git
echo DB_HOST : DB_HOST=${aws_db_instance.mysql_db.address} > /root/env_db_host.yaml
echo DB_USER : DB_USER=${var.my-db.DB_USER} >> /root/env_db_host.yaml
echo DB_DBNAME : DB_DBNAME=${var.my-db.DB_DBNAME} >> /root/env_db_host.yaml
echo MYSQL_ROOT_PASSWORD : MYSQL_ROOT_PASSWORD=${var.my-db.MYSQL_ROOT_PASSWORD} >> /root/env_db_host.yaml
ansible-playbook backend/nginx.yaml
sleep 11
ansible-playbook backend/nginx-start.yaml
EOF
}
#aws_alb_target_group.nginx.dns_name

resource "aws_autoscaling_group" "nginx" {
  min_size = 1
  max_size = 2
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.nginx.name
  vpc_zone_identifier  = "${var.subnets}"

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx.id
  lb_target_group_arn    = aws_alb_target_group.nginx.id
}

resource "aws_autoscaling_policy" "nginx-cpu-policy" {
    name = "nginx-cpu-policy"
    autoscaling_group_name = "${aws_autoscaling_group.nginx.name}"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

#클라우드 와치로 알람생성 평균 cpu사용량이 30프로 이상일경우
resource "aws_cloudwatch_metric_alarm" "nginx-cpu-alarm" {
    alarm_name = "nginx-cpu-alarm"
    alarm_description = "nginx-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "30"
    dimensions = {
        "AutoScalingGroupName" = "${aws_autoscaling_group.nginx.name}"
    }
    #알람이 실행이 이액션을 실행한다
    actions_enabled = true
    alarm_actions = ["${aws_autoscaling_policy.nginx-cpu-policy.arn}"]
}

#오토스케일 설정중 오토스케일 다운설정
resource "aws_autoscaling_policy" "nginx-cpu-policy-scaledown" {
    name = "nginx-cpu-policy-scaledown"
    autoscaling_group_name = "${aws_autoscaling_group.nginx.name}"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "-1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

#클라우드 와치로 알람생성 평균 cpu사용량이 5프로 이하일경우
resource "aws_cloudwatch_metric_alarm" "nginx-cpu-alarm-scaledown" {
    alarm_name = "nginx-cpu-alarm-scaledown"
    alarm_description = "nginx-cpu-alarm-scaledown"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "5"
    dimensions = {
        "AutoScalingGroupName" = "${aws_autoscaling_group.nginx.name}"
    }
    actions_enabled = true
    alarm_actions = ["${aws_autoscaling_policy.nginx-cpu-policy-scaledown.arn}"]
}
