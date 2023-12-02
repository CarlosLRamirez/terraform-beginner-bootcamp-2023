terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
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
