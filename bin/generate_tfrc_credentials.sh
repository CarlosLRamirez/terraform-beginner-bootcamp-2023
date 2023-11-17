#!/bin/bash

# Get the Terraform Cloud API token from the environment variable
terraform_token="$TERRAFORM_CLOUD_TOKEN"

# Check if the token is empty
if [ -z "$terraform_token" ]; then
  echo "Error: TERRAFORM_CLOUD_TOKEN environment variable is not set."
  exit 1
fi

# Set the path to the credentials file
credentials_file="/home/gitpod/.terraform.d/credentials.tfrc.json"

# Create the credentials file with the specified content
echo '{
  "credentials": {
    "app.terraform.io": {
      "token": "'"$terraform_token"'"
    }
  }
}' > "$credentials_file"

echo "Credentials file created at: $credentials_file"

