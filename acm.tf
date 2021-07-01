# spa/acm

data "aws_route53_zone" "zone" {
  name = "${var.hosted_zone}."
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "*.${var.hosted_zone}"
  subject_alternative_names = ["${var.hosted_zone}"]
  validation_method         = "DNS"
  tags                      = {}
}
[for record in aws_route53_record.existing : record.fqdn]
resource "aws_route53_record" "cert_validation" {
  name            = tolist(aws_acm_certificate.cert[each.key].domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.cert[each.key].domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.cert[each.key].domain_validation_options)[0].resource_record_value]
  zone_id = "${data.aws_route53_zone.zone.id}"
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

output "cert_arn" {
  value = "${aws_acm_certificate.cert.arn}"
}
