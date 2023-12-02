
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

    tags = {
    UserUUid        = var.user_uuid
    Environment = "Dev"
  }
}

