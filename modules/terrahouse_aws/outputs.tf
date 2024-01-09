output "bucket_name" {
    value = aws_s3_bucket.website_bucket.bucket
}
output "s3_website_endpoint" {
      value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

#output "cloudfront_endpoint" {
#    value = aws_cloudfront_distribution.default.domain_name
#}
