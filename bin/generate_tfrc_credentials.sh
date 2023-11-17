#!/bin/bash

# Get the Terraform Cloud API token from the environment variable
terraform_token="$TERRAFORM_CLOUD_TOKEN"

# Check if the token is empty
if [ -z "$terraform_token" ]; then
  echo "Error: TERRAFORM_CLOUD_TOKEN environment variable is not set."
  exit 1
fi

# Set the path to the credentials file and the .terraform.d folder
credentials_file="/home/gitpod/.terraform.d/credentials.tfrc.json"
terraform_folder="/home/gitpod/.terraform.d"

# Create the .terraform.d folder if it doesn't exist
if [ ! -d "$terraform_folder" ]; then
  mkdir -p "$terraform_folder"
fi

# Create the credentials file with the specified content
echo '{
  "credentials": {
    "app.terraform.io": {
      "token": "'"$terraform_token"'"
    }
  }
}' > "$credentials_file"

echo "Credentials file created at: $credentials_file"
