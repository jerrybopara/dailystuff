variable "aws_profile" {
  description = "AWS Account Profile to load"
  type        = string
  default     = "ir-jerry-test"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Value of Name - Tag"
  type           = string
  default        = "Example_Instance"
}
