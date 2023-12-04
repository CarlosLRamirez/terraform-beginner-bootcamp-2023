


#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

    tags = {
    UserUUid  = var.user_uuid
    Environment = "Dev"
  }
}

