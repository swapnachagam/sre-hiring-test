# Terraform code for all the AWS Resources 

This folder specifically containts the terraform code which is required to create 
- IAM ROLES/POLICIES
- S3 BUCKET
- LAMBDA FUNCTION
- API GATEWAY

I am storing the state locally now and haven't enabled a backend, but we can store the store in a s3 bucket 

I have created resource specific terraform files and a common output.tf and variables.tf 
config.tf contains the details of the terraform provider along with required providers needed for this execution 

Once code is verified, we can run below commands for applying in local or github actions will take of plan/applying on every pull requests 
- terraform init 
- terraform plan
- terraform apply 