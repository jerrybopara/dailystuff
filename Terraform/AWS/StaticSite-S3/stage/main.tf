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
    region = var.aws_region
}

# Region where aws support ACM
provider "aws" {
    alias = "acm_provider"
    region = var.aws_acm_region
}

module "s3" {
    source = "../modules/s3"
    bucket_name = var.bucket_name
    domain_name = var.domain_name
    common_tags = var.common_tags
}
