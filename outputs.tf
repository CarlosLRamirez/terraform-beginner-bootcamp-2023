output "bucket_name" {
    description = "Bucket name for our static web hosting"
    value = module.terrahouse_aws.bucket_name
}
output "s3_website_endpoint" {
    description = "S3 statis website hosting endpoint"
    value = module.terrahouse_aws.s3_website_endpoint
}
