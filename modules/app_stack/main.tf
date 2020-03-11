/*#Setup Jenkins Instance
resource "aws_instance" "app_instanceA" {
  ami           = var.jumpserver_ami
  instance_type = var.instance_type
  subnet_id = var.publicsubnet1_id
  vpc_security_group_ids = [var.internal_security_group_id, var.external_security_group_id]
  user_data = var.user_data
  key_name = var.instance_key
  iam_instance_profile = var.iam_instance_profile
  tags =  {
    Name = var.app_instanceA_name
    Terraform = true
  }
}*/


#Setup Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = var.loadbalancer_name
  internal           = var.loadbalancer_internal
  load_balancer_type = var.loadbalancer_type
  security_groups    = [var.internal_security_group_id]
  subnets            = [var.publicsubnet1_id, var.publicsubnet2_id]
  enable_deletion_protection = var.loadbalancer_deleteprotection

  /*  access_logs {
      bucket  = var.s3_bucket_logs
      prefix  = var.loadbalancer_accesslogs_prefix
      enabled = var.loadbalancer_accesslogs
    }*/

  tags =  {
    Terraform = true
  }
}

#Setup ALB target group
resource "aws_lb_target_group" "app_alb_target_group" {
  name     = var.app_alb_targetgroup_name
  port     = var.app_alb_port
  protocol = var.app_alb_protocol
  vpc_id   = var.vpc_id
  tags = {
    Terraform = true
  }
  stickiness {
    type            = var.app_alb_targetgroup_cookie_type
    cookie_duration = var.app_alb_targetgroup_cookie_duration
    enabled         = var.app_alb_targetgroup_sticky
  }
  health_check {
    healthy_threshold   = var.app_alb_targetgroup_healthy_threshold
    unhealthy_threshold = var.app_alb_targetgroup_unhealthy_threshold
    timeout             = var.app_alb_targetgroup_timeout
    interval            = var.app_alb_targetgroup_interval
    path                = var.app_alb_targetgroup_path
    port                = var.app_alb_port
    matcher             = var.app_healthcheck_responsecode
  }
}


#Setup application load balancer listener
resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port     = var.app_alb_port
  protocol = var.app_alb_protocol

  default_action {
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
    type             = var.app_alb_listener_type
  }
}

#Setup Jenkins Launch Configuration
resource "aws_launch_configuration" "app_launch_config" {
  name_prefix   = var.app_launchconfig_prefix
  image_id        = var.instance_ami
  instance_type   = var.instance_type
  security_groups = [var.internal_security_group_id]
  user_data = var.user_data
  key_name = var.instance_key
  iam_instance_profile = var.iam_instance_profile

  lifecycle {
    create_before_destroy = true
  }
}

#Setup Jenkins Placement Group
resource "aws_placement_group" "app_placement_group" {
  name     = var.vpcname
  strategy = var.app_asg_placement_group_strategy
}

#Setup Jenkins Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name = var.vpcname
  launch_configuration = aws_launch_configuration.app_launch_config.id
  min_size = var.autoscalinggroup_minsize
  max_size = var.autoscalinggroup_maxsize
  availability_zones = [var.availability_zone1, var.availability_zone2]
  vpc_zone_identifier       = [var.publicsubnet1_id, var.publicsubnet2_id]
  health_check_type = var.app_asg_healthchecktype
  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = var.asg_key
      value               = var.asg_value
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    }
  ]
}

#Attach Target Group to Auto Scaling Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  alb_target_group_arn   = aws_lb_target_group.app_alb_target_group.arn
}

#Attach Jenkins EC2 Instance A to Target Group
/*resource "aws_lb_target_group_attachment" "alb_attachmentA" {
  target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  target_id        = aws_instance.app_instanceA.id
  port             = var.app_alb_port
}*/

/*#Attach Jenkins EC2 Instance B to Target Group
resource "aws_lb_target_group_attachment" "alb_attachmentB" {
  target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  target_id        = aws_instance.app_instanceB.id
  port             = 80
}*/

#Set Route53 Record to Jenkins
resource "aws_route53_record" "app_record" {
  zone_id = var.app_lb_zoneid
  name    = var.lb_name
  type    = var.lb_type

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}


