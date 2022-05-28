output "vpc_id" {
  value = aws_vpc.mainvpc.id
}

output "subnet_id" {
  value = aws_subnet.public-subnet1.id
}

output "sg_id" {
  value = aws_security_group.public.id
}