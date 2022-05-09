output "vpc_id" {
  value = aws_vpc.mainvpc.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}