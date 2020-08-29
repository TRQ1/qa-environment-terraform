resource "aws_route53_record" "aws_route53_record" {
  zone_id = var.aws_route53_zone_id
  name    = var.aws_route53_record_name
  type    = var.aws_route53_record_type
  ttl     = "300"
  records = var.aws_route53_record_server
}