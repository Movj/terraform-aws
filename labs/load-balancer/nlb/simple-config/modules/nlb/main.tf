data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.vpc.id
}

#Creating target group for Apache 
resource "aws_lb_target_group" "apache_tg" {
  name        = "Apache-TG"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.apache_tg.arn
  target_id        = var.ec2_instance_id
  port             = 80
}

#Creating target group for NGINX 
resource "aws_lb_target_group" "nginx_tg" {
  name        = "Nginx-TG"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = var.ec2_instance_id
  port             = 8080
}

#Creating Load balancer
resource "aws_lb" "loadbalancer" {
  name               = "MyNetwork-LB"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.subnet.ids
}

#Adding listeners
resource "aws_lb_listener" "listner1" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache_tg.arn
  }
}
resource "aws_lb_listener" "listner2" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}