resource "aws_launch_configuration" "launch_config" {
  count = length(var.launch_configs)

  name_prefix   = var.launch_configs[count.index].name_prefix
  image_id        = var.launch_configs[count.index].image_id
  instance_type   = var.launch_configs[count.index].instance_type
  security_groups = var.launch_configs[count.index].security_groups
  key_name = var.launch_configs[count.index].key_name
  iam_instance_profile = var.launch_configs[count.index].iam_instance_profile
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  count = length(var.asg_configs)

  name = var.asg_configs[count.index].name
  launch_configuration = aws_launch_configuration.launch_config[count.index].id
  min_size = var.asg_configs[count.index].min_size
  max_size = var.asg_configs[count.index].max_size
  availability_zones = var.asg_configs[count.index].availability_zones
  vpc_zone_identifier       = var.asg_configs[count.index].vpc_zone_identifier
  health_check_type = var.asg_configs[count.index].health_check_type
  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = "Name"
      value               = var.asg_configs[count.index].asg_instance_name
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  count = length(var.asg_configs)

  autoscaling_group_name = aws_autoscaling_group.autoscaling_group[count.index].id
  alb_target_group_arn   = var.asg_configs[count.index].target_group
}
