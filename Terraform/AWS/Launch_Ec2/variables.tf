variable "aws_profile" {
  description = "AWS Account Profile to load"
  type        = string
  default     = "ir-jerry-test"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}

# ENV NAME OR STACK NAME
variable "infra_env" {
  description = "infrastructure environment"
  type        = string
  # default     = "Jerry-Lab"
}

# Default CIDR for VPC
variable "vpc_cidr" {
  default = "192.168.0.0/21"
}

# VPC Tenancy 
variable "tenancy" {
  default = "default"
}

# Subnet CIDR - 1
variable "subnet_cidr" {
  default = "192.168.0.0/24"
}

# Servers you want in your ENV/STACK
variable "ec2_count" {
  default = 1
}
# Define the Instane Type 
variable "instance_type" {
  default = "t3.micro"
}
# Define the Instance Name here 
variable "instance_name" {
  type = string
  # default = "ServerName"
}

# Define the Login SSH KEY Name
variable "key_name" {
  type    = string
  default = "default_key"
}

# Define the Instance AMI 
variable "ami_id" {
  # default = "ami-0dc5e9ff792ec08e3"
}
