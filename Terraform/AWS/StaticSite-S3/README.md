=> To list the TF Workspace's 
$ terraform workspace list

=> To Create new WorkSpace
$ terraform workspace new DOMAIN NAME

=> To Switch/Select workspace
$ terraform workspace select DOMAIN NAME

=> To Delete the WorkSpace
$ terraform workspace d

=======================================================

=> Command to init the TF
$ terraform init -backend-config=tfstate.conf -reconfigure

=> Command to run the plan/test run.
$ terraform plan -var-file terraform.tfvars

=> Command to Apply the Changes.
$ terraform apply -var-file terraform.tfvars 

$ terraform plan -var-file terraform.tfvars -var="infra_env=jerrybopara" -var="domain_name=jerrybopara.com" -var="bucket_name=jerrybopara.com"

$ terraform plan -var-file terraform.tfvars -var="infra_env=jerrybopara" -var="domain_name=jerrybopara.com" -var="bucket_name=jerrybopara.com"


$ aws s3 cp --recursive pet-shelter s3://www.zhnzp.com/ --region "us-east-1" --profile ir-jerry-test

$ aws s3 rm s3://www.zhnzp.com/ --recursive --region "us-east-1" --profile ir-jerry-test
=======================================================
Readme Notes 
1) Create - terraform.tfvars, with following vars.
    # Vars for S3 Backend 
    profile=""
    region="us-east-1"
    bucket=""
    key=""



=======================================================
Note:
1) aws_s3_bucket deperecated.
  - Have to setup s3 with aws_s3_bucket_cors_configuration

https://www.oss-group.co.nz/blog/automated-certificates-aws


https://dev.to/ustundagsemih/how-to-pass-variables-to-a-json-file-in-terraform-57k1
https://registry.terraform.io/providers/hashicorp/aws/4.0.0/docs/resources/s3_bucket_website_configuration
