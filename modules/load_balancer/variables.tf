
variable "lb_configs" {
  description = "Configuration for the Load Balancers"
  type = list(object({ name=string, internal=bool, load_balancer_type=string, security_groups=list(string),
    subnets=list(string), enable_deletion_protection=bool }))
}

variable "tg_configs" {
  description = "Configuration for the Target Groups"
  type = list(object({ name=string, port=number, protocol=string, vpc_id=string, stickiness_type=string,
    stickiness_cookie_duration=number, stickiness_enabled=bool, health_check_healthy_threshold=number,
    health_check_unhealthy_threshold=number, health_check_timeout=number, health_check_interval=number,
    health_check_path=string, health_check_port=number, health_check_matcher=number }))
}

variable "listener_configs" {
  description = "Configuration for the Listeners"
  type = list(object({ port=number, protocol=string, type=string }))
}
