variable "bucket_name" {
  description = "Must be unique aws-wide"
  type        = string
  default     = "abror-bucket-project"
}
variable "arn_my_sns_topic" {
  default = ""
}
