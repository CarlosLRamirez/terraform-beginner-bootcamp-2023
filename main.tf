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
  cloud {
    organization = "CarlosLRamirez"

    workspaces {
      name = "terra-house-1"
    }
  }
}  


provider "random" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  profile = "default"
}


resource "random_string" "bucket_name" {
  length = 16
  lower = true
  upper = false
  special = false
}

locals {
    bucket_name = join("-", ["mybucket", random_string.bucket_name.result])
}

#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name
}

output "random_bucket_name" {
    value = local.bucket_name
}

