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


resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket 

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "index.html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = 

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("path/to/file")
}