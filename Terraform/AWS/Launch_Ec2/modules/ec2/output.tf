# output "ec2_public_ip" {
#     value = aws_instance.instance.public_ip
# }
output "Instance_EIP" {
    value = aws_eip.ElasticIp.public_ip
}