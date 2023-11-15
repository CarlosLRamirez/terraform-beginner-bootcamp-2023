# Local environment Setup instruccions for MacOS Sonoma

This should be done only one time, in your local enviornment

## Install Terraform CLI

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform

### Enable tab completion (optional)
touch ~/.bashrc
terraform -install-autocomplete
```

## Install AWS CLI

```sh
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg ./AWSCLIV2.pkg -target /
which aws
aws --version
```

## Add you environmental variables
git
### AWS Credentials

Add this lines to the `~./bash_profile` file:

```sh
export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
export AWS_DEFAULT_REGION='us-west-2'
export AWS_CLI_AUTO_PROMPT='on-partial'
export AWS_PAGER=""
```


