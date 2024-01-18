variable "teacherset_user_uuid" {
  description = "User UUID"
  type        = string
}

variable "terratowns_access_token" {
  description = "Terratown access token"
  type        = string
}


variable "terratowns_endpoint" {
  description = "terratowns endpoint"
  type        = string
}

#variable "bucket_name" {
#  description = "Name of the AWS S3 bucket"
#  type        = string
#}

variable "riseofnations" {
  type        = object({
    public_path = string
    content_version = number
  }) 
}

variable "atitlan" {
  type        = object({
    public_path = string
    content_version = number
  }) 
}





