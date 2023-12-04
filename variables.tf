variable "user_uuid" {
  description = "User UUID"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}

variable "bucket_name" {
  description = "Name of the AWS S3 bucket"
  type        = string
  validation {
    condition     = regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name)
    error_message = "Invalid bucket name. It must be between 3 and 63 characters long and can only contain alphanumeric characters, hyphens, and dots."
  }
}
