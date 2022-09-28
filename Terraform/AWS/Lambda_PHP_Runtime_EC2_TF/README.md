# ProjectName_LambdaRuntime_TF
**Contains the codebase which used to setup AWS LAMBDA php runtime.**

## This Codebase will launch a EC2 Instance and Install the following things - 

- Amazon Linux 2 [ami-0ff8a91507f77f867] - [Amazon Machine Image](https://aws.amazon.com/amazon-linux-ami/).

- TF Provisioner - [ scripts/InstallScript.sh - This script will install all below listed packages on server. ]
    - AWS CLI [AWS COMMAND LINE](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip)
    - OPEN SSL [Openssl-1.0.1k](http://www.openssl.org/source/openssl-1.0.1k.tar.gz)
    - PHP - [PHP 7.3](https://github.com/php/php-src/archive/php-7.3.0.tar.gz)
    - BootStrap [Download From here](https://raw.githubusercontent.com/aws-samples/php-examples-for-aws-lambda/master/0.1-SimplePhpFunction/bootstrap)
    - PHP Composer - [Composer.phar](https://getcomposer.org/installer)
    - Composer Packages 
        - guzzlehttp/guzzle
        - swiftmailer/swiftmailer:^6.0
        - aws/aws-sdk-php
        - phpzip/phpzip


## Git Repo - https://github.com/jerrybopara/dailystuff.git

```
$ cd ProjectName_LambdaRuntime_TF/
$ git clone https://github.com/jerrybopara/dailystuff.git
```

> ### ***There are 2 branches in the repo - Dev [devlopment] & Main [master]***


## Copy ***"terraform.tfvars_sample"*** to ***"terraform.tfvars"*** and Update values as per needs.
```
$ cp terraform.tfvars_sample terraform.tfvars

```
> ## FYI - TF Using S3 Bucket Backend to store ***"terraform.tfstate"***. 

    bucket         = "BUCKET-tfstate-store"
    key            = "LambdaRuntime_TF_State/terraform.tfstate"



## Terraform - Let's run the setup.
```
$ terraform init
$ terraform plan
```
## If all seems fine at TF PLAN, then apply the setup.
```
$ terraform apply 
```

## Finally logged into the Server & Do the following - 
- Login to the server.
    ```
    $ ssh ec2-user@ELASTIC-IP
    ```
- Runtime will be found at following locations 
    ```
    $ cd /home/ec2-user/environment/php-7-bin
    $ ls -ld runtime.zip vendor.zip 
      -rw-rw-r-- 1 ec2-user ec2-user 48051345 Aug 30 06:16 runtime.zip
      -rw-rw-r-- 1 ec2-user ec2-user  5353324 Aug 30 06:16 vendor.zip 
    ```
- Configure AWS CLI [ AWS CLI configured with "--profile" option. [Read More](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) ]
    ```
    $ aws configure --profile AWS_IAM_PROFILE

    ``` 


- Configure AWS CLI, So that we can push the runtime & vendor zip to lambda runtime.
    ```
    $ aws --profile AWS_IAM_PROFILE lambda publish-layer-version --layer-name php7-vendor-layer --zip-file fileb://vendor.zip --region us-east-1
    $ aws --profile AWS_IAM_PROFILE lambda publish-layer-version --layer-name php7-runtime-layer --zip-file fileb://runtime.zip --region us-east-1
    ``` 

## Now your Runtime is Pushed to AWS => LAMBDA => LAYERS. 
## SetUp Lambda Function & API GATEWAY

## Read More 

-   AWS Lambda Custom Runtime for PHP : [Read More](https://aws.amazon.com/blogs/apn/aws-lambda-custom-runtime-for-php-a-practical-example/)


##  :) Thanks