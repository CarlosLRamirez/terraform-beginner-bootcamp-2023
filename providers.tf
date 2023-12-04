terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
 
  #cloud {
  #  organization = "CarlosLRamirez"
  #
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
}  

provider "random" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  
}
