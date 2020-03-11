output "lb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "asg_arn" {
  value = var.vpcname
}

output "asg_instance_name" {
  value = var.asg_value
}

