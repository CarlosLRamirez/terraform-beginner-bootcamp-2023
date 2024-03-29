
#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "aws_s3_bucket" "website_bucket" {
  #bucket = var.bucket_name
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

# https://developer.hashicorp.com/terraform/language/functions/fileset
# https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${var.public_path}/assets/","*.{jpg,png,gif}")
  bucket = aws_s3_bucket.website_bucket.bucket 
  key = "assets/${each.key}"
  source = "${var.public_path}/assets/${each.key}"
  etag = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output ]
    ignore_changes = [ etag ]    
  } 
}

resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  #source = "${path.root}/public/index.html"
  source = "${var.public_path}/index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
  #etag = filemd5("${path.root}/public/index.html")
  etag = filemd5("${var.public_path}/index.html")
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output ]
    ignore_changes = [ etag ]    
  }
}

resource "aws_s3_object" "errorfile" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  #source = "${path.root}/public/index.html"
  source = "${var.public_path}/error.html"
  content_type = "text/html"


  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
  #etag = filemd5("${path.root}/public/index.html")
  etag = filemd5("${var.public_path}/error.html")
}



# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" =  "Allow",
      "Principal" = {
        "Service" = "cloudfront.amazonaws.com"
      },
      "Action" = "s3:GetObject",
      "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition" = {
        "StringEquals" = {
          "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.default.id}"
        }
      }
    },        
  })
}


/* data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
} */


resource "terraform_data" "content_version" {
  input = var.content_version
}

#resource "terraform_data" "append_html" {
#  triggers_replace= {
#    content_version = var.content_version
#  }
#
#  provisioner "local-exec" {
#    command = "echo '${var.content_version}' >> /workspace/terraform-beginner-bootcamp-2023/public/index.html"
#  }
#}
