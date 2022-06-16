cd ../environments/dev
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy

OR 
terraform -chdir="./environments/dev" init/plan/apply

