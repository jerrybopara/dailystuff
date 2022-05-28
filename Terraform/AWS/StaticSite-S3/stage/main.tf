terraform {
  #   required_version = ">= 0.15"
  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  # We add in the backend configuration - S3 Bucket  
  backend "s3" {}

}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# Region where aws support ACM
provider "aws" {
  profile = var.aws_profile
  alias   = "acm_provider"
  region  = var.aws_acm_region
}

module "s3bucket" {
  source      = "../modules/s3"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
  common_tags = var.common_tags
}

module "route53" {
  source      = "../modules/route53"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
  common_tags = var.common_tags

  root_s3_distribution_domain               = module.cloudfront.root_s3_distribution-domain_name
  root_s3_distribution_zoneid               = module.cloudfront.root_s3_distribution-hosted_zone_id
  www_s3_distribution_domain                = module.cloudfront.www_s3_distribution-domain_name
  www_s3_distribution_zoneid                = module.cloudfront.www_s3_distribution-hosted_zone_id
  ssl_certificate-domain_validation_options = module.aws-acm.aws_acm_certificate-ssl_certificate
}

module "aws-acm" {
  source                             = "../modules/acm"
  bucket_name                        = var.bucket_name
  domain_name                        = var.domain_name
  common_tags                        = var.common_tags
  aws_route53_record-cert_validation = module.route53.aws_route53_record-cert_validation
}

module "cloudfront" {
  source                     = "../modules/cloudfront"
  bucket_name                = var.bucket_name
  domain_name                = var.domain_name
  common_tags                = var.common_tags
  domain-bucket-endpoint     = module.s3bucket.dom-bucket-endpoint
  www-domain-bucket-endpoint = module.s3bucket.www-dom-bucket-endpoint
  acm-cert-validation-arn    = module.aws-acm.certificate-validation-certificate_arn

}

output "Route53_NS" {
  value       = module.route53.NameServers
  description = "Name Servers are: "
}