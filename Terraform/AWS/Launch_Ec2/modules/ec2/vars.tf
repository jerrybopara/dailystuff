variable "infra_env" {
  description = "infrastructure environment"
  type        = string
  default     = "Jerry-Lab"
}

variable "instance_name" {} # Instance Name
variable "ami_id" {}        # Instance AMI ID 
variable "subnet_id" {}     # Subnet ID of VPC - mainvpc Public Subnet 
variable "sg_id" {}         # Security Group Created in VPC

# Number of instance needs to be launched.
variable "ec2_count" {
  default = 1
}

# Instance Type.
variable "instance_type" {
  default = "t3.micro"
}