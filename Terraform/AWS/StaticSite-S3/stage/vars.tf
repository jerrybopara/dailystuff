# Note - Define all these variables in variables.tfvars

variable "aws_profile" {
  description = "AWS Account Profile to load"
  type        = string

}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_acm_region" {
  description = "AWS ACM Region"
  type        = string
  default     = "us-east-1"
}

# ENV NAME OR STACK NAME
variable "infra_env" {
  description = "infrastructure environment"
  type        = string
}

# App Name 
variable "application" {
  description = "App Name"
  type        = string
}

## - Domain & Bucket Name Vars
variable "domain_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "common_tags" {
  description = "Common Tag"
}
