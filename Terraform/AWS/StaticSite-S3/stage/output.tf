output "instance_id" {
    description = "Instance ID"
    value       = aws_instance.jerry_app_server.id
}

output "instance_public_ip" {
    description = "Elastic Ip"
    value       = aws_instance.jerry_app_server.public_ip
}

output "instance_vpc_id" {
    description = "Instance VPC ID"
    value       = aws_instance.jerry_app_server.vpc_security_group_ids 
}