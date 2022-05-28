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

https://medium.com/@aliatakan/terraform-create-a-vpc-subnets-and-more-6ef43f0bf4c1

https://www.youtube.com/watch?v=IpN0ZiXmufM

https://cloudcasts.io/course/terraform/creating-our-vpc-module

