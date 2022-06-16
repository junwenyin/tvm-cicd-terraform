cd ../environments/dev
terraform init
terraform plan
terraform apply
terraform destroy

terraform -chdir="./environments/dev" apply --auto-approve

HOW to run on cloud
gcloud compute instances create-with-container tvm-job-vm-100004 --project=gnomondigital-sandbox --zone=europe-west1-b --machine-type=n1-standard-1 --boot-disk-size=100G --container-image=gcr.io/gnomondigital-sandbox/optimizer:0.2 --service-account=tvm-job-runner@gnomondigital-sandbox.iam.gserviceaccount.com --scopes=cloud-platform  --container-command=python  --container-arg="main.py" --container-arg="--path" --container-arg="gs://gnomondigital-sandbox-tvm-job-input/job_id=100004/config.json"

HOW to run on local machine


{"bucket":"gnomondigital-sandbox-tvm-job-input", "name": "job_id=100004/config.json"}
{"job_id":"100004", "status": "success"}


