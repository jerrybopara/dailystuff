resource "aws_key_pair" "loginkey" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCusc/nK5sEyn4rPCBS4IriFXm27I43JTrWhrpUn2JQDP5olbjWS35JGCZE8mc1N2Un4S3+/73IgwHqIGBhA4HsSWxnabIrJDKeBdWjMQByg3wLKOFUogp6sy86yszpAvUtOxdpNxNUymFUyb75gZZqTlgywb0s82d2iDIgs3dKZsNILdVOUSetAtSqbGv/MGtdCvz62PbCIFyKRkpW4Fep/oKzCk/bZAtx3ItlIZE4ZDeOT0CJ4tWNjKKvJDNGQoj5Hj6gqG5ih4XZqz2wjJpcQpDE8uVyb8xBEcUDZbxlbiMPEY1D4EXBVbSqUuVquFH1ELyLvRz4tVYYJQK2bQe51oBPqC7pbyWW7wdb+qm2vwXa8kii+PHiKdG6ddfXdTVktV5moo1AbiRj9BBxzwx4SMkWPb5RuhF6qJvPO3rEtQDB4leT5SAHQ1u0zrvRg8QvEs9QGZZL2+Mhn3V4ggQ8kqwYremjYbDqS8E4sw2cbKgjDNR22Vdwykdou7Aunrk= jerry@ideapad"
}

# Declare the data source
# data "aws_availability_zones" "available" {
#   state = "available"
# }

resource "aws_instance" "instance" {
  # Choosing the AZ - us-east-1e
  # availability_zone = data.aws_availability_zones.available.names[0]
  count           = var.ec2_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.sg_id

  key_name                    = var.key_name
  associate_public_ip_address = true


  tags = {
    Name = "${var.infra_env}-${var.instance_name}"
  }

  root_block_device { 
    volume_size = 80
    delete_on_termination = true
  } 

  # Define UserData Here - 
  # user_data = <<-EOF
  #               #! /bin/bash
  # EOF
}




