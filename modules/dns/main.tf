resource "aws_route53_record" "dns_record" {
  count = length(var.configs)

  zone_id = var.configs[count.index].zone_id
  name    = var.configs[count.index].name
  type    = var.configs[count.index].type

  alias {
    name                   = var.configs[count.index].lb_name
    zone_id                = var.configs[count.index].lb_zone_id
    evaluate_target_health = var.configs[count.index].evaluate_target_health
  }
}
