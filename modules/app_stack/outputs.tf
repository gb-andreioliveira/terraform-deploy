output "lb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "asg_arn" {
  value = var.vpcname
}
