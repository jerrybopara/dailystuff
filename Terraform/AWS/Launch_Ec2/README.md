# Setup Ec2 Instance with custom env. 
<!--  -->
- Create VPC 
- Create Internet Gateway
- Create Custom Routing Table
- Create Subnet's 
- Associate Subnet with Route Table
- Create Security Group to allow Port 22, 80, 443
- Create a ENI with an IP in the subnet that was created above.
- Assign EIP to the ENI
- Launch Ubuntu Server with Apache2 


## terraform.rfvars 

```
aws_profile   = "AWS_PROFILE_NAME"
aws_region    = "us-east-1"
infra_env     = ""
vpc_cidr      = "192.168.0.0/21"
subnet_cidr   = "192.168.0.0/24"
instance_type = "t2.medium"
instance_name = "ServerName"
ami_id        = "ami-0c4f7023847b90238" # Ubuntu 20.04 LTS
key_name      = "SSH KEY NAME"
```


```
$ terraform init && terraform fmt   
$ terraform plan
$ terraform apply

```


<!--  -->