#!/usr/bin/env bash

brew tap hashicorp/tap

brew install hashicorp/tap/terraform

brew update

brew upgrade hashicorp/tap/terraform

#Enable tab completion (optional)

touch ~/.bashrc
terraform -install-autocomplete