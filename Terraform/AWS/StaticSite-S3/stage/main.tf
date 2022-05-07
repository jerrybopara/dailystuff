terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "ir-jerry-test"
  region  = "us-east-1"
}

resource "aws_instance" "jerry_app_server" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  key_name      = "IR-PMTA-AWS"

  tags = {
    "Name" = "Example_jerry_app_server"
  }

}