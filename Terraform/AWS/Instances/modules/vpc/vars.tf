# ENV NAME 
variable "infra_env" {
  description = "infrastructure environment"
  type        = string
  default     = "Jerry-Lab"
}

# This variabble is mandatory, but should be passwd while execution.
variable "vpc_id" {}

# VPC Tenancy 
variable "tenancy" {
  default = "default"
}

# Default CIDR for VPC
variable "vpc_cidr" {
  default = "192.168.0.0/21"
}

# Subnet CIDR 
variable "subnet_cidr" {
  default = "192.168.0.0/24"
}
