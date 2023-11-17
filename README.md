# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging. [semver.org](https://semver.org/)

The general format is:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Terraform CLI Installation

### Considerations with the Terraform CLI changes
The Terraform CLI installation instruction have changed due to gpg keyring changes. So we need refer to the last install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.

Please consider checking your Linux Distribution and change accordingly to your distribution needs.

[How To Check OS Version in Linux](https://www.tecmint.com/check-linux-os-version/)

Example of checking OS Version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI deprecation issues we noticed the bash scripts steps were a considerable amount more code. So we decided to create a bash scripts to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli.sh](./bin/install_terraform_cli.sh)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy
- This allow us easier to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI


#### Shebang Considerations

A Shebang (pronounces Sha-bang) tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

It's recommended this format of shebang `#!/usr/bin/env bash` 

- for portability for different OS distribution
- It provides PATH Independence, and reduce Reduced Hardcoding

[About Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash scripts we can use the `./`shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli.sh`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli.sh`

#### Linux Permission Considerations

In order to make our bash scripts executable we need to change linux permission for the fix can be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

```sh
chmod 744 ./bin/install_terraform_cli
```

[About Linux Permissions](https://en.wikipedia.org/wiki/Chmod)

[Chmod Calculator](https://chmod-calculator.com/)

### Gitpod Lifecycle (Before, Init, Command)

We need to careful when using the Init because it will not re-run if we restart an existing workspace.

[About Gitpod Tasks](https://www.gitpod.io/docs/configure/workspaces/tasks)


### Working with Environment Variables

#### env command
We can list out all Environment Variables (Env Vars) using `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsettling Env Varas

In the terminal we can se using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set and env var temporarily when just running a command (passing to a bash script)

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print and env using echo eg. `echo $HELLO`

#### Scoping on Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another windows.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in our bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing then in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set vars in the `gitpod.yml` but this can only contain non-sensitive env vars.


## AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli.sh)

[Getting Started Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

We can check if our AWS credentials are configured correctly by running the following command AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that look like this:

```json
{
    "UserId": "AIAATF7CZDSYEXAMPLEUV",
    "Account": "222374085051",
    "Arn": "arn:aws:iam::123456085552:user/terraform-beginner"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

[Random Terraform provider](https://registry.terraform.io/providers/hashicorp/random/latest)

- **Providers** is an interface to APIs that will allow to create resources in terraform
- **Modules** are a way to make large amount of terraform code modular, portable and sharable. 

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

### Terraform Plan

`terraform plan` 

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be be passed to an apply, but ofter you can just ignore outputting.

### Terraform Apply

`terraform apply` 

Thiss will run a plan and pass the changeset to be execute by terraform. Apply should prompt us yes or no.

If we want to automatically approve an apply we can provide the auto approve flag. `terraform apply --auto-approve`


### Terraform Destroy

You can use `terraform destroy` to destroy all the resources you created

You can also use the auto approve flag. `terraform destroy --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock file should be committed to your Version Control System (VCS) eg. Github

### Terraform State Files

`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be committed** to your Version Control System (VCS) eg. Github

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will lauch bash a wiswig view to generate a token. However it does not work as expected in Gitpod VsCode in the browser

The workaround is manually generate a tocken in Terraform Cloud.

[Tokens](https://app.terraform.io/app/settings/tokens)

Then create and open the file manually here: 

```
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file)

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

## References

https://www.tecmint.com/check-linux-os-version/
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
https://en.wikipedia.org/wiki/Shebang_(Unix)
https://en.wikipedia.org/wiki/Chmod
https://chmod-calculator.com/
https://www.gitpod.io/docs/configure/workspaces/tasks