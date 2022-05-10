
=> Command to init the TF
$ terraform init -backend-config=tfstate.conf 

=> Command to run the plan
$ terraform plan -var-file variables.tfvars 