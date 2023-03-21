module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "front-end-svc-alb"

  load_balancer_type = "application"

  vpc_id          = var.default_vpc_id
  subnets         = var.subnets
  security_groups = [var.target_sg]

  /* access_logs = {
    bucket = "my-alb-logs"
  } */

  target_groups = [
    {
      name_prefix      = "tg-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        fe-svc-tg = {
          target_id = var.target_id
          port      = 80
          health_check = {
            enabled             = true
            port                = "80"
            timeout             = 30
            matcher             = "200"
            interval            = 2
            path                = "/"
            healthy_threshold   = 2
            unhealthy_threshold = 3
          }
        }
      }
    }
  ]

  /* https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ] */

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}


// We can define a target group outside the balancer, or in-line

/* resource "aws_lb_target_group" "alb-http-front-end-svc" {
  name        = "alb-tg-http-front-end-svc"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.default_vpc_id
  health_check {
    enabled = true
    port = "80"
    timeout = 30
    matcher = "200"
    interval = 2
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
} 

resource "aws_lb_target_group_attachment" "tg-assignment-to-alb" {
  target_id = var.target_id
  target_group_arn = aws_lb_target_group.alb-http-front-end-svc.arn
  port = 80
}

resource "aws_lb_listener" "lb_listener_http" {
   load_balancer_arn    = module.alb.id
   port                 = "80"
   protocol             = "HTTP"
   default_action {
    target_group_arn = aws_lb_target_group.alb-http-front-end-svc.id
    type             = "forward"
  }
}
*/