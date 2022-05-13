# Global Variables - 
variable "domain_name" {}
variable "bucket_name" {}
variable "common_tags" {}
variable "aws_route53_record-cert_validation" {}

# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  # provider                  = aws.acm_provider
  provider                  = aws

  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  # validation_method         = "EMAIL"
  validation_method         = "DNS"

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert_validation" {
  # provider        = aws.acm_provider
  provider        = aws

  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in var.aws_route53_record-cert_validation : record.fqdn]
  # validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


output "certificate-validation-certificate_arn" {
    value = aws_acm_certificate_validation.cert_validation.certificate_arn
}

# Progress
output "aws_acm_certificate-ssl_certificate" {
    value = aws_acm_certificate.ssl_certificate.domain_validation_options 
}
