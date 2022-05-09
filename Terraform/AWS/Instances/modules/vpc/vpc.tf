resource "aws_vpc" "mainvpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name        = "${var.infra_env}-vpc"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.infra_env}-public-subnet"
  }
}

resource "aws_internet_gateway" "internet-igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "${var.infra_env}-igw"
  }

}


