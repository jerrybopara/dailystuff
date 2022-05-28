=> Command to create Reusable dns delegation set.
$ aws route53 create-reusable-delegation-set  --caller-reference MyDelegationSet_Name

=> Command to list the NS Reusable delegation sets. 
$ aws --profile ir-jerry-test --region us-east-1 route53 list-reusable-delegation-sets



=> 
$ 

aws --profile ir-jerry-test --region us-east-1 route53 create-hosted-zone 
--name marketersend.xyz --caller-reference marketersend --delegation-set-id "/delegationset/N01039852QO65UBK9W8JJ"

======================================================

=> To list the TF Workspace's 
$ terraform workspace list

=> To Create new WorkSpace
$ terraform workspace new DOMAIN NAME

=> To Switch/Select workspace
$ terraform workspace select DOMAIN NAME

=> To Delete the WorkSpace
$ terraform workspace delete

=======================================================

=> Command to init the TF
$ terraform init -backend-config=tfstate-s3.conf -reconfigure

=> Command to run the plan/test run.
$ terraform plan -var-file terraform.tfvars

=> Command to Apply the Changes.
$ terraform apply -var-file terraform.tfvars 

$ terraform plan -var-file terraform.tfvars -var="infra_env=jerrybopara" -var="domain_name=jerrybopara.com" -var="bucket_name=jerrybopara.com"

$ terraform apply -var-file terraform.tfvars -var="infra_env=zhnzp" -var="domain_name=zhnzp.com" -var="bucket_name=zhnzp.com"

$ terraform destroy -var-file terraform.tfvars -var="infra_env=zhnzp" -var="domain_name=zhnzp.com" -var="bucket_name=zhnzp.com"

$ aws s3 cp --recursive pet-shelter s3://www.zhnzp.com/ --region "us-east-1" --profile ir-jerry-test

$ aws s3 rm s3://www.marketersend.xyz/ --recursive --region "us-east-1" --profile ir-jerry-test
======================================================
terraform destroy -var-file terraform.tfvars -var="domain_name=zhnzp.com" -var="bucket_name=zhnzp.com"

=====
=> Run Jenkins job via api.
$ curl -X POST http://54.227.21.17:8080/job/Jerry-TEST-Pipeline/buildWithParameters --user jerry:118ce6b1c5e063258d407b6aa2ce6b26e3 --form 'domain_name="ajdevtech.com"' --form 'bucket_name="ajdevtech.com"' --form 'tfwork_space="ajdevtech.com"' --form 'Action="apply"'


$ curl -X GET http://54.227.21.17:8080/api/json?pretty=true --user jerry:118ce6b1c5e063258d407b6aa2ce6b26e3
=====
curl -X POST http://54.227.21.17:8080/job/Jerry-TEST-Pipeline/buildWithParameters --user jerry:118ce6b1c5e063258d407b6aa2ce6b26e3 --form 'domain_name="zhnzp.com"' --form 'bucket_name="zhnzp.com"' --form 'tfwork_space="zhnzp.com"' --form 'Action="apply"'

curl -X POST http://54.227.21.17:8080/job/Job1-AddRootZone-AWS/buildWithParameters --user jerry:118ce6b1c5e063258d407b6aa2ce6b26e3 --form 'domain_name="jerrydev1.com"' --form 'bucket_name="jerrydev1.com"' --form 'tfwork_space="jerrydev1.com"' --form 'Action="apply"'
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

https://medium.com/everything-full-stack/dynamically-manage-and-maintain-multiple-terraform-environment-lifecycles-with-jenkins-44f144b273f2  

https://www.oss-group.co.nz/blog/automated-certificates-aws



https://dev.to/ustundagsemih/how-to-pass-variables-to-a-json-file-in-terraform-57k1
https://registry.terraform.io/providers/hashicorp/aws/4.0.0/docs/resources/s3_bucket_website_configuration
