
import os
import json
from google.cloud.devtools import cloudbuild_v1

PROJECT = os.environ.get('PROJECT', "gnomondigital-sandbox")
ZONE = os.environ.get('ZONE', "europe-west1-b")

build_client = cloudbuild_v1.CloudBuildClient()

def create_build_config(attrs: dict):
    job_id = attrs['job_id']
    machine_name = "tvm-job-vm-{}".format(job_id)
    machine_type = attrs['machine_type']
    image_version = attrs.get("image_version", "latest")
    container_image = f"gcr.io/{PROJECT}/optimizer:{image_version}"
    disk_size = attrs.get("disk_size", "30G")

    build = {
        "steps": [{
            "name": "gcr.io/cloud-builders/gcloud",
            "entrypoint":"bash",
            "args": [
            "-c",
            f"gcloud compute instances create-with-container {machine_name} \
                --project={PROJECT} --zone={ZONE} --machine-type={machine_type} --boot-disk-size={disk_size} --container-image={container_image} \
                --service-account=tvm-job-runner@{PROJECT}.iam.gserviceaccount.com --scopes=cloud-platform --container-restart-policy=never \
                --container-command='python' --container-arg='app/main.py' --container-arg='--env' --container-arg=1 --container-arg='--job_id' --container-arg={job_id} \
                --container-arg='--input_bucket' --container-arg='{PROJECT}-tvm-job-input' --container-arg='--output_bucket' --container-arg='{PROJECT}-tvm-job-output' \
                --container-arg='--topic_id' --container-arg='tvm-job-clean-topic' --container-arg='--project_id' --container-arg='{PROJECT}'"
        ]
        }]
    }
    return build

def create_build(attrs: dict):
    build_config = create_build_config(attrs)
    operation = build_client.create_build(project_id=PROJECT, build=cloudbuild_v1.Build(build_config))

    # Print the in-progress operation
    print("IN PROGRESS:")
    print(operation.metadata)

    result = operation.result()
    # Print the completed status
    print("RESULT:", result.status)

def hello_pubsub(event, context):

    print("""This Function was triggered by messageId {} published at {} to {}
    """.format(context.event_id, context.timestamp, context.resource["name"]))
    attrs = event.get('attributes', None)

    if ('job_id' in attrs) & ('machine_type' in attrs):
        create_build(attrs)
    else:
        print('Nothing to do, bye!')
