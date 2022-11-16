variable "endpoint" {
  type        = string
  description = "The Harness API endpoint"
  default     = "https://app.harness.io/gateway"
}

variable "account_id" {
  type        = string
  description = "The id of of your Harness Account."
  default     = ""
  sensitive   = true
}

variable "platform_api_key" {
  type        = string
  description = "This is either your Harness user PAT or Harness Service account token."
  default     = ""
  sensitive   = true
}

variable "org_name" {
  type = string
  description = "The name of the team (organisation)"
}

variable "org_id" {
  type = string
  description = "The id for the team (organisation)"
}