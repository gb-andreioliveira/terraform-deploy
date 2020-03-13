output "asg_arn" {
  value = var.asg_configs[0].name
}

output "asg_instance_name" {
  value = var.asg_configs[0].asg_instance_name
}