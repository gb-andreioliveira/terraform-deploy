variable "configs" {
  description = "Configuration for the Route 53 recods"
  type = list(object({ name=string, zone_id=string, type=string ,lb_name=string, lb_zone_id=string, evaluate_target_health=bool}))
}
