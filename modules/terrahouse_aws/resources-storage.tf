
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

resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  #source = "${path.root}/public/index.html"
  source = var.index_html_filepath

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
  #etag = filemd5("${path.root}/public/index.html")
  etag = filemd5(var.index_html_filepath)
}

resource "aws_s3_object" "errorfile" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  #source = "${path.root}/public/index.html"
  source = var.error_html_filepath

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
  #etag = filemd5("${path.root}/public/index.html")
  etag = filemd5(var.error_html_filepath)
}