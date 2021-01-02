output "zone_id" {
    value = join("", aws_route53_zone.primary.*.id)
}
