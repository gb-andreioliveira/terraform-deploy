#Setup Application Load Balancer
resource "aws_lb" "load_balancer" {
  count = length(var.lb_configs)

  name               = var.lb_configs[count.index].name
  internal           = var.lb_configs[count.index].internal
  load_balancer_type = var.lb_configs[count.index].load_balancer_type
  security_groups    = var.lb_configs[count.index].security_groups
  subnets            = var.lb_configs[count.index].subnets
  enable_deletion_protection = var.lb_configs[count.index].enable_deletion_protection

  tags =  {
    Terraform = true
  }
}

#Setup ALB target group
resource "aws_lb_target_group" "lb_targetgroup" {
  count = length(var.tg_configs)

  name     = var.tg_configs[count.index].name
  port     = var.tg_configs[count.index].port
  protocol = var.tg_configs[count.index].protocol
  vpc_id   = var.tg_configs[count.index].vpc_id
  tags = {
    Terraform = true
  }
  stickiness {
    type            = var.tg_configs[count.index].stickiness_type
    cookie_duration = var.tg_configs[count.index].stickiness_cookie_duration
    enabled         = var.tg_configs[count.index].stickiness_enabled
  }
  health_check {
    healthy_threshold   = var.tg_configs[count.index].health_check_healthy_threshold
    unhealthy_threshold = var.tg_configs[count.index].health_check_unhealthy_threshold
    timeout             = var.tg_configs[count.index].health_check_timeout
    interval            = var.tg_configs[count.index].health_check_interval
    path                = var.tg_configs[count.index].health_check_path
    port                = var.tg_configs[count.index].health_check_port
    matcher             = var.tg_configs[count.index].health_check_matcher
  }
}



#Setup application load balancer listener
resource "aws_lb_listener" "lb_listener" {
  count = length(var.listener_configs)

  load_balancer_arn = aws_lb.load_balancer[count.index].arn
  port     = var.listener_configs[count.index].port
  protocol = var.listener_configs[count.index].protocol

  default_action {
    target_group_arn = aws_lb_target_group.lb_targetgroup[count.index].arn
    type             = var.listener_configs[count.index].type
  }
}

