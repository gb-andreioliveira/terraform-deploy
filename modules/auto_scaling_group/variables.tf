variable "launch_configs" {
  description = "Configuration for the Launch Configurations"
  type = list(object({ name_prefix=string, image_id=string, instance_type=string, security_groups=list(string),
    key_name=string, iam_instance_profile=string}))
}

variable "asg_configs" {
  description = "Configuration for the Launch Configurations"
  type = list(object({ name=string, min_size=string, max_size=string, availability_zones=list(string),
    vpc_zone_identifier=list(string), health_check_type=string, asg_instance_name=string,
    target_group = string}))
}
