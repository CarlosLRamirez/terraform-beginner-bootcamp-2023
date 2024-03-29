variable "user_uuid" {
  description = "User UUID"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}

#variable "bucket_name" {
#  description = "Name of the AWS S3 bucket"
#  type        = string
#  validation {
#    condition     = can(regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name))
#    error_message = "Invalid bucket name. It must be between 3 and 63 characters long and can only contain alphanumeric characters, hyphens, and dots."
#  }
#}

variable "public_path" {
  description = "The Path of the public directory"
  type        = string

#  validation {
#    condition     = fileexists(var.index_html_filepath)
#    error_message = "The specified file path does not exist."
#  }

}



variable "content_version" {
  description = "Version number for content"
  type        = number

  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "Content version must be a positive integer starting at 1."
  }
}

