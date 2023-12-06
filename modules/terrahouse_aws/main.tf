terraform {
    required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}


#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  tags = {
    UserUUid  = var.user_uuid
  }
}

