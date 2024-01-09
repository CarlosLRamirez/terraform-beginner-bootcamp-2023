output "bucket_name" {
    description = "Bucket name for our static web hosting"
    value = module.terrahouse_aws.bucket_name
}
output "s3_website_endpoint" {
    description = "S3 statis website hosting endpoint"
    value = module.terrahouse_aws.s3_website_endpoint
}

#output "cloudfront_endpoint" {
#    description = "Domain name for the CloudFront Distribution"
#    value = module.terrahouse_aws.cloudfront_endpoint
#}

locals {
    root_path = path.root
}

output "root_path" {
    value = local.root_path
}