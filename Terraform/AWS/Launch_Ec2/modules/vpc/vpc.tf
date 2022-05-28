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

# Define Public Subnet 1
resource "aws_subnet" "public-subnet1" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.infra_env}-public-subnet1"
  }
}

# Internet GateWay - 
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "${var.infra_env}-igw1"
  }

}

# Route Table for Public Subnet
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "${var.infra_env}-rtb1"
  }
}

# Assosiate Internet GateWay & Route Table
resource "aws_route_table_association" "public-subnet1_rtb1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.rtb1.id
}

###
# Public Security Group
## 
resource "aws_security_group" "public" {
  name        = "${var.infra_env}-public-sg"
  description = "Public internet access"
  vpc_id      = aws_vpc.mainvpc.id

  tags = {
    Name        = "${var.infra_env}-public-sg"
    Role        = "public"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}


