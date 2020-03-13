output "dns_name" {
  value = aws_lb.load_balancer[*].dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.lb_targetgroup[*].arn
}

output "lb_zone_id" {
  value = aws_lb.load_balancer[*].zone_id
}
