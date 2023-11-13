#!/usr/bin/env bash

# Terraform CLI Installation Instructions
# for Linux - Ubuntu/Debian

#Ensure that your system is up to date and you have prerequisite packages installed 
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

#Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

#Verify the key's fingerprint.
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

#Add the official HashiCorp repository to your system. 
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

#Download the package information from HashiCorp.
sudo apt update

#Install Terraform from the new repository.
sudo apt-get install terraform -y


