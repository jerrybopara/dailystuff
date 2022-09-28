# ## => Code to import local ssh keys to aws.
# resource "aws_key_pair" "mykey" {
#   key_name = "${var.PubKeyName}"
#   public_key = "${file("${var.Public_Key_Path}")}"
# }

# Setup a VPC
resource "aws_vpc" "custom_vpc" {
    cidr_block = "${var.VPC_CIDR}"
    
    tags = {
        Name = "VPC_${var.ProJectName}"
    }
}

# Create subnets for different parts of the infrastructure
resource "aws_subnet" "subnet_1a" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  
    tags = {
        Name = "AZ-1a_${var.AWS_REGION}"
    }    
}

# Attach an internet gateway to the VPC
resource "aws_internet_gateway" "custom_ig" {
    vpc_id = aws_vpc.custom_vpc.id

    tags = {
        Name = "IG_${var.ProJectName}"
    }
}

# Create a route table for a public subnet
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_ig.id
    }

    route {
        ipv6_cidr_block  = "::/0"
        gateway_id       = aws_internet_gateway.custom_ig.id
    }

    tags = {
        Name = "Public_RT_${var.ProJectName}"
    }
}

# Associate Public RT to Public Subnet
resource "aws_route_table_association" "public_1_rt_a" {
    subnet_id = aws_subnet.subnet_1a.id
    route_table_id = aws_route_table.public_rt.id
}

# Create security groups to allow specific traffic
resource "aws_security_group" "my_sg" {
    name = "OfficeIP_FUll-Access"
    vpc_id = aws_vpc.custom_vpc.id

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["112.196.87.42/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Create ec2 instances on the created VPC/Subnet

resource "aws_instance" "Lambda_Runtime" {
    ami = "${var.AMI}"
    instance_type = "${var.InstanceType}"
    # key_name = "${aws_key_pair.mykey.key_name}"
    key_name = "${var.PubKeyName}"
    subnet_id = aws_subnet.subnet_1a.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]

    associate_public_ip_address = true

    tags = {
        Name = "${var.InstanceName}"
    }  

    provisioner "file" {
        source = "scripts/InstallScript.sh"
        destination = "/tmp/InstallScript.sh"
    }
   
    provisioner "remote-exec" {
        inline = [
            "sudo hostnamectl set-hostname ${var.HostName}",
            "chmod +x /tmp/InstallScript.sh",
            "/tmp/InstallScript.sh"
        ]
    }
    connection {
      host = aws_instance.Lambda_Runtime.public_ip
      user = "${var.UserName}"
      private_key = "${file("${var.Private_Key_Path}")}"
    }
}
