
 output "bucket_name_riseofnations" {
    description = "Bucket name for our static web hosting"
    value = module.home_riseofnations_hosting.bucket_name
}
output "s3_website_endpoint_riseofnations" {
    description = "S3 statis website hosting endpoint"
    value = module.home_riseofnations_hosting.s3_website_endpoint
}

output "domain_name_riseofnations" {
    description = "Domain name for the CloudFront Distribution"
    value = module.home_riseofnations_hosting.domain_name
}



 output "bucket_name_atitlan" {
    description = "Bucket name for our static web hosting"
    value = module.home_atitlan_hosting.bucket_name
}
output "s3_website_endpoint_atitlan" {
    description = "S3 statis website hosting endpoint"
    value = module.home_atitlan_hosting.s3_website_endpoint
}

output "domain_name_atitlan" {
    description = "Domain name for the CloudFront Distribution"
    value = module.home_atitlan_hosting.domain_name
}



